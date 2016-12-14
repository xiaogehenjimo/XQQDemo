//
//  XQQMessageTool.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQMessageTool.h"
#import "AppDelegate.h"
#import "XQQCallViewController.h"






@interface XQQMessageTool ()<EMChatManagerDelegate,UIAlertViewDelegate,EMCallManagerDelegate>
/** 好友名称 */
@property (nonatomic, copy)  NSString  *  userName;
/** 弹窗 */
@property(nonatomic, strong)  UIAlertView * alert;

//最后一次播放
/** <#class#> */
@property(nonatomic, strong)  NSDate  *  lastPlaySoundDate;

@end

@implementation XQQMessageTool


+ (instancetype)sharedMessageTool{
    static XQQMessageTool * messageTool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        messageTool = [[XQQMessageTool alloc]init];
    });
    return messageTool;
}


#pragma mark - 接收消息
/*收到一条消息*/
- (void)didReceiveMessage:(EMMessage *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:XQQNoticDidRecieveMessage object:message];
//#if !TARGET_IPHONE_SIMULATOR
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self showNotificationWithMessage:message];
    }
//#endif
    //插入到数据库中
    //[[XQQDataManager sharedDataManager] insertMessage:message];
}


/*进行本地推送*/
- (void)showNotificationWithMessage:(EMMessage*)message{
    NSString * messageStr = [self analyseMessageWithMessage:message];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    NSString *title = message.from;
    if (message.isGroup) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:message.conversation.chatter]) {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                break;
            }
        }
    }
    notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
}





- (void)playSoundAndVibration{
    //如果距离上次响铃和震动时间太短, 则跳过响铃
    NSLog(@"%@, %@", [NSDate date], self.lastPlaySoundDate);
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < 20) {
        return;
    }
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    // 收到消息时，播放音频
    //[[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    //[[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}


#pragma mark -当接收到验证消息时，会调用的方法


- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    NSLog(@"请求好友为：%@ 申请语句为：%@",username,message);
    self.userName = username;
    //UIAlertViewStylePlainTextInput
    _alert = [[UIAlertView alloc]initWithTitle:@"好友申请" message:[NSString stringWithFormat:@"%@申请添加你为好友",username] delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [_alert show];
}

/*建立代理连接*/
- (void)buildDelegateConnect{
    //建立代理连接
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self addCallDelegate];
}

/*添加视频语音通话代理*/
- (void)addCallDelegate{
    //通话的代理
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
/*移除视频语音代理连接*/
- (void)removeDelegateConnect{
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}


#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    if (callSession.status == eCallSessionStatusConnected)
    {
        EMError *error = nil;
        do {
            BOOL isShowPicker = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowPicker"] boolValue];
            if (isShowPicker) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
            if (![self canRecord]) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
#warning 在后台不能进行视频通话
            if(callSession.type == eCallSessionTypeVideo && ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive || ![XQQCallViewController canVideo])){
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            if (!isShowPicker){
                [self removeDelegateConnect];
                XQQCallViewController *callController = [[XQQCallViewController alloc] initWithSession:callSession isIncoming:YES];
                callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                //获得当前活跃控制器
                UIViewController * currentVC = [[XQQManager sharedManager] getCurrentVC];
                [currentVC presentViewController:callController animated:NO completion:nil];
            }
        } while (0);
        
        if (error) {
            [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReasonHangup];
            return;
        }
    }
}

- (void)callOutWithChatter:(NSDictionary *)dict
{
    if (![self canRecord]) {
        return;
    }
    EMError *error = nil;
    NSString *chatter = [dict objectForKey:@"chatter"];
    NSString * type = [dict objectForKey:@"type"];
    EMCallSession *callSession = nil;
    if ([type isEqualToString:@"eCallSessionTypeAudio"]) {
        callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:20 error:&error];
    }
    else if ([type isEqualToString:@"eCallSessionTypeVideo"]){
        if (![XQQCallViewController canVideo]) {
            return;
        }
        callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:20 error:&error];
    }
    
    if (callSession && !error) {
        [self removeDelegateConnect];
        XQQCallViewController *callController = [[XQQCallViewController alloc] initWithSession:callSession isIncoming:NO];
        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        //当前活跃的控制器
        UIViewController * currentController = [[XQQManager sharedManager] getCurrentVC];
        [currentController presentViewController:callController animated:NO completion:nil];
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error") message:error.description delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _alert) {
        [_alert dismissWithClickedButtonIndex:0 animated:NO];
        _alert = nil;
        if (buttonIndex == 0) {
            //拒绝
            UIAlertView * rejustAlert = [[UIAlertView alloc]initWithTitle:@"拒绝申请" message:@"输入你要拒绝的话" delegate:self cancelButtonTitle:@"残忍拒绝" otherButtonTitles:nil, nil];
            rejustAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [rejustAlert show];
        }else{
            //同意
            BOOL isSuc = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.userName error:nil];
            if (isSuc) {
                XQQLog(@"同意对方添加自己为好友");
            }else{
                XQQLog(@"添加失败");
            }
        }
    }else{
        UITextField * textField = [alertView textFieldAtIndex:0];
        BOOL isSuc =  [[EaseMob sharedInstance].chatManager rejectBuddyRequest:self.userName reason:textField.text error:nil];
        if (isSuc) {
            XQQLog(@"拒绝成功");
        }else{
            XQQLog(@"拒绝失败");
        }
    }
}

/*创建文字消息*/
- (EMMessage*)createTextMessageWithFrindName:(NSString*)frindName
                                         Str:(NSString*)messageStr
                                 messageType:(EMMessageType)messageType{
    EMChatText * text = [[EMChatText alloc]initWithText:messageStr];
    EMTextMessageBody * body = [[EMTextMessageBody alloc]initWithChatObject:text];
    EMMessage * message = [[EMMessage alloc]initWithReceiver:frindName bodies:@[body]];
    message.messageType = messageType;
    return message;
}

/*创建图片消息*/
- (EMMessage*)createImageMessageWithFrindName:(NSString*)frindName
                                    sendImage:(UIImage*)sendImage
                                  messageType:(EMMessageType)messageType{
    EMChatImage *imgChat = [[EMChatImage alloc] initWithUIImage:sendImage displayName:@"back.jpeg"];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:imgChat];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:frindName bodies:@[body]];
    message.messageType = messageType;
    return message;
}

/*创建语音消息*/
- (EMMessage*)createVoiceMessage:(NSString *)recordPath
                        duration:(NSInteger)duration
                      friendName:(NSString*)friendName
                     messageType:(EMMessageType)messageType{
    EMChatVoice *chatVoice = [[EMChatVoice alloc] initWithFile:recordPath displayName:@"[语音]"];
    EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithChatObject:chatVoice];
    voiceBody.duration = duration;
    // 2.构造一个消息对象
    EMMessage *msg = [[EMMessage alloc] initWithReceiver:friendName bodies:@[voiceBody]];
    msg.messageType = messageType;
    return msg;
}

/*构建位置消息*/
- (EMMessage*)createLocationMessage:(NSString*)friendName
                      locationModel:(BMKPoiInfo*)locationModel
                        messageType:(EMMessageType)messageType{
    EMChatLocation *locChat = [[EMChatLocation alloc] initWithLatitude:locationModel.pt.latitude longitude:locationModel.pt.longitude address:locationModel.address];
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithChatObject:locChat];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:friendName bodies:@[body]];
    message.messageType = messageType;
    return message;
}

/**
 计算消息时间
 
 @param newTime 当前消息的时间
 @param oldTime 这条消息上一条消息
 
 @return 如果时间超过300秒  返回时间 不超过返回空
 */
- (NSString*)calculateTimeNewMessageTime:(long long)newTime
                                 oldTime:(long long)oldTime{
    // 今天 11:20
    // 昨天 23:23
    // 前天以前 11:11
    // 1. 创建一个日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 2. 获取当前时间
    NSDate *currentDate = [NSDate date];
    // 3. 获取当前时间的年月日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    // 4. 获取发送时间
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:newTime/1000];
    //获取上一条消息的时间
    NSDate * oldDate = [NSDate dateWithTimeIntervalSince1970:oldTime/1000];
    //计算两个时间之间的差
    
    //计算现在的时间 和退出页面时间之间的间距 以秒为单位
    NSInteger ddd = (NSInteger)[sendDate timeIntervalSinceDate:oldDate];
    //2分钟才显示
    if (ddd > 120) {
        // 5. 获取发送时间的年月日
        NSDateComponents *sendComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sendDate];
        NSInteger sendYear = sendComponents.year;
        NSInteger sendMonth =  sendComponents.month;
        NSInteger sendDay = sendComponents.day;
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        // 6. 当前时间与发送时间的比较 @"yyyy-MM-dd HH:mm:ss"
        if (currentYear == sendYear &&
            currentMonth == sendMonth &&
            currentDay == sendDay) {// 今天
            fmt.dateFormat = @"今天 HH:mm";
        }else if(currentYear == sendYear &&
                 currentMonth == sendMonth &&
                 currentDay == sendDay + 1){
            fmt.dateFormat = @"昨天 HH:mm";
        }else if(currentYear == sendYear&&currentMonth == sendMonth){
            fmt.dateFormat = @"MM-dd HH:mm";
        }else{
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        }
        return  [fmt stringFromDate:sendDate];
    }
    return @"";
}

/* 时间的转换*/
- (NSString *)conversationTime:(long long)time{
    
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    //进行日期判断  2016-10-18 14:50:02
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * createAtDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    if ([createAtDate isThisYear_XQQadd]) {//是今年
        if (createAtDate.isToday_XQQadd) {//是不是今天
            //当前时间
            NSDate * nowDate = [NSDate date];
            //获得两个日期之间的间隔
            NSCalendarUnit unit = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
             NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents * comps = [calendar components:unit fromDate:createAtDate toDate:nowDate options:0];
            if (comps.hour >= 1) {//时间间隔>=1小时
                return [NSString stringWithFormat:@"%zd小时前",comps.hour];
            }else if (comps.minute >= 1){//1小时>时间间隔>=1小时
                return [NSString stringWithFormat:@"%zd分钟前",comps.minute];
            }else{//1分钟>时间间隔
                return @"刚刚";
            }
        }else if (createAtDate.isYesterday_XQQadd){//昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createAtDate];
        }else{//其他天
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createAtDate];
        }
    }else{//不是今年
        return [fmt stringFromDate:createAtDate];
    }
}
#pragma mark - 解析消息
- (NSString*)analyseMessageWithMessage:(EMMessage*)message{
    //获得消息体
    
    NSString * returnStr = @"";
    
    id <IEMMessageBody> msgBody = message.messageBodies.firstObject;
    //需要对消息类型判断 做对应的操作
    switch ([msgBody messageBodyType]) {
        case eMessageBodyType_Text:{
            //获取到的文字
            returnStr = ((EMTextMessageBody *)msgBody).text;
        }
            break;
        case eMessageBodyType_Image:
        {
            returnStr = @"[图 片]";
        }
            break;
        case eMessageBodyType_Voice:
        {
            returnStr = @"[语 音]";
        }
            break;
        case eMessageBodyType_Location:
        {
            returnStr = @"[位 置]";
        }
            break;
        case eMessageBodyType_Video:
        {
            returnStr = @"[视 频]";
        }
            break;
        default:
            break;
    }
    return returnStr;
}



#pragma mark - canVideo
-(BOOL)canVideo{
    BOOL canvideo = YES;
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    NSLog(@"---cui--authStatus--------%ld",(long)authStatus);
    if(authStatus ==AVAuthorizationStatusRestricted){//此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"Restricted");
        canvideo = NO;
        return canvideo;
    }else if(authStatus == AVAuthorizationStatusDenied){//用户已经明确否认了这一照片数据的应用程序访问.
        // The user has explicitly denied permission for media capture.
        NSLog(@"Denied");     //应该是这个，如果不允许的话
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
        canvideo = NO;
        return canvideo;
    }
    else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问,用户已授权应用访问照片数据.
        NSLog(@"Authorized");
        canvideo = YES;
        return canvideo;
    }else if(authStatus == AVAuthorizationStatusNotDetermined){//用户尚未做出了选择这个应用程序的问候
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {//请求访问照相功能.
            //应该在打开视频前就访问照相功能,不然下面返回不了值啊.
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
                
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
    }else {
        NSLog(@"Unknown authorization status");
        canvideo = NO;
    }
    return canvideo;
}

- (BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    if (!bCanRecord) {
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setting.microphoneNoAuthority", @"No microphone permissions") message:NSLocalizedString(@"setting.microphoneAuthority", @"Please open in \"Setting\"-\"Privacy\"-\"Microphone\".") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alt show];
    }
    return bCanRecord;
}
@end
