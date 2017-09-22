//
//  AppDelegate.m
//  XQQChatProj
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
//  Created by 徐勤强 on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//
//7.0.8
#import "AppDelegate.h"
#import "MainViewController.h"
#import "XQQChatViewController.h"
#import "XQQNavigationController.h"
#import "XQQLoginViewController.h"
#import <EaseMobSDKFull/EaseMob.h>
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "GTMBase64.h"



@interface AppDelegate ()<EMChatManagerDelegate,UIAlertViewDelegate>
@property (nonatomic, copy)NSString * userName;//记录申请的好友名字
/*是否通过推送信息进入的应用*/
@property (nonatomic) BOOL isLaunchedByNotification;
/** 弹窗 */
@property(nonatomic, strong)  UIAlertView * alert;

@end

@implementation AppDelegate
{
    BMKMapManager* _mapManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        _isLaunchedByNotification = YES;
        [XQQManager sharedManager].isPush = YES;
    }else{
        [XQQManager sharedManager].isPush = NO;
        _isLaunchedByNotification = NO;
    }
    
    //NSString * from = remoteNotification[@"f"];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self judge];
    [self createDir];
    //百度地图初始化
    _mapManager = [[BMKMapManager alloc]init];
    //如果要关注网络及授权验证事件，请设定   generalDelegate参数
    BOOL ret = [_mapManager start:@"1yCPGCgKuUHyvyqET5DfUYbxl7bIG6sU"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //环信  ljstronger#ljweixin  302673849#csc 302673849#newchat
    //302673849#xqqchatnewproj
    //kSDKConfigEnableConsoleLogger 去除控制台打印log
    //producPush   生产推送证书
    //测试推送证书    XQQChatPushCer
    //李丽   lilipush
     [[EaseMob sharedInstance] registerSDKWithAppKey:@"302673849#xqqchatnewproj" apnsCertName:@"VChatPUSH" otherConfig:@{kSDKConfigEnableConsoleLogger:@NO}];
    
    /*建立消息 通话 代理连接*/
    //[[XQQMessageTool sharedMessageTool] buildDelegateConnect];
    //建立代理连接
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //bmob 后端云
    [Bmob registerWithAppKey:@"f0544fda2dd216c8ed11a4de7fbf30c0"];
    //蒲公英
    //启动基本SDK
//    [[PgyManager sharedPgyManager] startManagerWithAppId:@"a61a06f0ba055d9ea29d47ccb2142a29"];
    //启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"a61a06f0ba055d9ea29d47ccb2142a29"];
    /*获取群列表*/
    [self getGroupList];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    return YES;
}
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    NSLog(@"请求好友为：%@ 申请语句为：%@",username,message);
    self.userName = username;
    //UIAlertViewStylePlainTextInput
    _alert = [[UIAlertView alloc]initWithTitle:@"好友申请" message:[NSString stringWithFormat:@"%@申请添加你为好友",username] delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [_alert show];
}



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

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    //NSLog(@"error -- %@",error);
}

- (void)judge{
    //判断是否设置自动登录
    [XQQManager sharedManager].isAutoLogin = [EaseMob sharedInstance].chatManager.isAutoLoginEnabled;
    [XQQManager sharedManager].userName = [XQQUtility unarchiveDataFromCache:@"userName"].firstObject;
    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        //设置登录状态
        [[XQQUserInfoTool sharedManager] changeMyStates:YES];
        //跳转主页面
        [self jumpToMainVC];
    }else{
        [self toLoginVC];
    }
}
- (void)createDir{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/XQQDB", pathDocuments];
    [XQQManager sharedManager].dbPath = createPath;
    //    XQQLog(@"创建的文件夹:%@",createPath);
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
}

/*获取群聊列表*/
- (void)getGroupList{
    // 从服务端获取群列表
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
    } onQueue:nil];
}

- (void)jumpToMainVC{
    MainViewController * mainVC = [[MainViewController alloc]init];
    self.window.rootViewController = mainVC;
    //获取个人信息
    [[XQQUserInfoTool sharedManager] getMyInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonInfo:) name:XQQNoticPersonInfo object:nil];
}

- (void)toLoginVC{
    XQQLoginViewController * loginVC = [[XQQLoginViewController alloc]init];
    self.window.rootViewController = loginVC;
}

/*获取到当前登录的个人信息会走这个方法*/
- (void)getPersonInfo:(NSNotification*)notic{
    NSArray * infoArr = (NSArray*)notic.object;
    BmobObject * ff = infoArr[0];
    NSString * nickName = [ff objectForKey:@"nickName"];
    NSString * iconURL = [ff objectForKey:@"iconURL"];
    [XQQManager sharedManager].nickName = nickName;
    [XQQManager sharedManager].uploadIconName = iconURL;
    [XQQManager sharedManager].iconURL = iconURL;
    
    //更新本地数据库个人信息
    [[XQQDataManager sharedDataManager] updatePersonTable:@{@"userName":[XQQManager sharedManager].userName,@"imageURL":iconURL,@"nickName":nickName}];
    //设置推送昵称
    EMPushNotificationOptions * option = [[EMPushNotificationOptions alloc]init];
    option.displayStyle = ePushNotificationDisplayStyle_messageSummary;
    option.nickname = nickName;
    [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:option completion:^(EMPushNotificationOptions *options, EMError *error) {
        
    } onQueue:nil];
    //[[EaseMob sharedInstance].chatManager setApnsNickname:nickName];
}

#pragma mark - 收到消息

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

- (void)registerUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}


- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    NSLog(@" application Recieved Notification %@",notif);
    app.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo{
    //推送过来的字典
    if (_isLaunchedByNotification) {
        NSDictionary * apnsInfoDict = userInfo[@"aps"];
        [XQQManager sharedManager].pushDict = userInfo;
        [[NSNotificationCenter defaultCenter] postNotificationName:XQQNoticeRecieveRemoteNotice object:userInfo];
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                //此时app在前台运行，我的做法是弹出一个alert，告诉用户有一条推送，用户可以选择查看或者忽略
        
            }else if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
                //这里是app未运行或者在后台，通过点击手机通知栏的推送消息打开app时可以在这里进行处理，比如，拿到推送里的内容或者附加      字段(假设，推送里附加了一个url为 www.baidu.com)，那么你就可以拿到这个url，然后进行跳转到相应店web页，当然，不一定必须是web页，也可以是你app里的任意一个controll，跳转的话用navigation或者模态视图都可以
            }
        //这里设置app的图片的角标为0，红色但角标就会消失
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }else{
        [XQQManager sharedManager].pushDict = nil;
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
}

/*进行本地推送*/
- (void)showNotificationWithMessage:(EMMessage*)message{
    
    NSString * messageStr = [[XQQMessageTool sharedMessageTool] analyseMessageWithMessage:message];
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
    UIApplication * application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    application.applicationIconBadgeNumber += 1;
}


#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //程序将要退出的时候
    //设置登录状态
    //[[XQQUserInfoTool sharedManager] changeMyStates:NO];
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}



@end
