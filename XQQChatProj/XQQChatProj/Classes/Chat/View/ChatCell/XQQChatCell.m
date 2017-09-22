//
//  XQQChatCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/24.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatCell.h"
#import <UIButton+WebCache.h>

#define boardWidth 10
#define allSubViewHeight 44
@interface XQQChatCell ()
/*时间label*/
@property(nonatomic, strong)  UILabel     *  timeLabel;
/** 左头像 */
@property(nonatomic, strong)  XQQChatBtn  *  leftChatIcon;
/** 右头像 */
@property(nonatomic, strong)  XQQChatBtn  *  rightChatIcon;


@end

@implementation XQQChatCell


+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexPath{
    static NSString * cellID = @"chatCellID";
    XQQChatCell * chatCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!chatCell) {
        chatCell = [[XQQChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    chatCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return chatCell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //时间label
        UILabel * timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.backgroundColor = XQQColor(200, 200, 200);
        timeLabel.layer.cornerRadius = 2.0;
        timeLabel.layer.masksToBounds = YES;
        timeLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        //聊天消息
        XQQChatBtn * chatBtn = [XQQChatBtn createXQQButton];
        chatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //chatBtn.backgroundColor = [UIColor redColor];
        //内边距
        chatBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 20, 25, 20);
        [chatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chatBtn.titleLabel.numberOfLines = 0;
        [chatBtn addTarget:self action:@selector(chatBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        self.chatBtn = chatBtn;
        [self.contentView addSubview:chatBtn];
        //又头像按钮
        XQQChatBtn * rightIconBtn = [XQQChatBtn createXQQButton];
        //rightIconBtn.backgroundColor = [UIColor redColor];
        self.rightChatIcon = rightIconBtn;
        [self.contentView addSubview:rightIconBtn];
        
        //左头像
        XQQChatBtn * leftBtn = [XQQChatBtn createXQQButton];
        self.leftChatIcon = leftBtn;
        //leftBtn.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:leftBtn];
    
    }
    return self;
}


#pragma mark - Activity

/*内容的按钮点击了*/
- (void)chatBtnDidPress:(XQQChatBtn*)button{
    
}

- (void)setMessage:(EMMessage *)message{
    _message = message;
    //拿到当前的登录用户
    NSString * userName = [XQQManager sharedManager].userName;
    //NSString * username = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    //获取消息体
    id body = message.messageBodies[0];
    //当前消息前面的一条消息
    NSArray * befordArr = [self.conversation loadNumbersOfMessages:1 withMessageId:message.messageId];
    EMMessage * latestMessage;
    if (befordArr.count > 0) {
        latestMessage = befordArr[0];
    }
    //计算两个时间间隔  如果大于2分钟 显示消息时间
    NSString * timeStr = [[XQQMessageTool sharedMessageTool] calculateTimeNewMessageTime:message.timestamp oldTime:latestMessage.timestamp];
    //计算文字的宽度
    if ([timeStr isEqualToString:@""]) {
        self.timeLabel.text = @"";
        self.timeLabel.hidden = YES;
        //没有
    }else{
        //有
//        CGSize textSize = [timeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        CGFloat textWidth = [timeStr widthWithFont:[UIFont systemFontOfSize:13] constrainedToHeight:20];
        
        self.timeLabel.text = timeStr;
        
        self.timeLabel.frame = CGRectMake((iphoneWidth - textWidth - 10)/2, 0, textWidth + 10, 20);
        
        self.timeLabel.hidden = NO;
    }
    //判断消息类型
    if ([body isKindOfClass:[EMTextMessageBody class]]) {//文本类型
        EMTextMessageBody * textBody = body;
        self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        NSAttributedString * attributedStr = textBody.text.attributedText;

        [self.chatBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.chatBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
        //这里 转换文本
        
        CGSize btnSize = [attributedStr boundingRectWithSize:CGSizeMake(iphoneWidth/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGSize realSize = CGSizeMake(btnSize.width + 40, btnSize.height + 30);
        self.chatBtn.xqq_size = realSize;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){//语音
        EMVideoMessageBody * voiceBody = body;
        //设置图片和时间
        [self.chatBtn setAttributedTitle:nil forState:UIControlStateNormal];//复用导致语音上面显示富文本
        [self.chatBtn setTitle:[NSString stringWithFormat:@"%zd'",voiceBody.duration] forState:UIControlStateNormal];
        self.chatBtn.xqq_size = CGSizeMake(allSubViewHeight + 50, allSubViewHeight + 15);
        if ([message.from isEqualToString:userName]) {//本人发送的
            [self.chatBtn setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"] forState:UIControlStateNormal];
            //图片在右面
            self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(0,40,0,0);
            self.chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-20,0,self.chatBtn.imageView.frame.size.width);
        }else{//好友发送的
            [self.chatBtn setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
            self.chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
        }
    }else if ([body isKindOfClass:[EMImageMessageBody class]]){//图片
        self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(-12, -12, -13, -11);
        [self.chatBtn setTitle:@"" forState:UIControlStateNormal];
        self.chatBtn.imageView.layer.cornerRadius = 4.0;
        self.chatBtn.imageView.layer.masksToBounds = YES;
        self.chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //图片消息体
        EMImageMessageBody * imageMessageBody = body;
        // 获得本地预览图片的路径
        NSString * path = imageMessageBody.localPath;
        NSFileManager * fileMgr = [NSFileManager defaultManager];
        NSURL * url = [fileMgr fileExistsAtPath:path] ? [NSURL fileURLWithPath:path] : [NSURL URLWithString:imageMessageBody.remotePath];
        //图片的size
        CGSize imageSize = imageMessageBody.thumbnailSize;
//        self.chatBtn.imageView.frame
        [self.chatBtn.imageView setContentMode:UIViewContentModeScaleToFill];
        self.chatBtn.imageView.clipsToBounds = YES;
        //只存在两种图片形式
        //宽高比
        //CGFloat  scale = imageSize.width/imageSize.height;
        
        if (imageSize.width - imageSize.height > 0) {//宽大于高 横着
            self.chatBtn.xqq_size = CGSizeMake(allSubViewHeight * 4 + 20, allSubViewHeight * 2 + 50);
        }else{//竖着
            self.chatBtn.xqq_size = CGSizeMake(allSubViewHeight * 2 + 50, allSubViewHeight * 4 + 20);
        }
//        self.chatBtn.xqq_size = CGSizeMake(allSubViewHeight*2 + 40, allSubViewHeight*2 + 40);
        
        [self.chatBtn sd_setImageWithURL:url forState:UIControlStateNormal];
    }else if ([body isKindOfClass:[EMVideoMessageBody class]]){//视频
        self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }else if ([body isKindOfClass:[EMLocationMessageBody class]]){//位置
        
        self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(-12, -12, -13, -11);
        self.chatBtn.imageView.layer.cornerRadius = 4.0;
        self.chatBtn.imageView.layer.masksToBounds = YES;
        self.chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //位置消息体
        EMLocationMessageBody * locationBody = body;
        //位置地址信息
        NSString * addressStr = locationBody.address;
        
        //拼接百度参数
        NSString * tmpStr = @"http://api.map.baidu.com/staticimage/v2?ak=KGMQ34ZLmyu3pkzXV84jD9sheailt2N6&mcode=UIP.XQQHXProj&center=%.7f,%.7f&width=300&height=200&zoom=16&markers=%.7f,%.7f";
        NSString * str = [NSString stringWithFormat:tmpStr,locationBody.longitude,locationBody.latitude,locationBody.longitude,locationBody.latitude];
        self.chatBtn.xqq_size = CGSizeMake(allSubViewHeight * 4 + 20, allSubViewHeight * 2 + 50);
        [self.chatBtn sd_setImageWithURL:[NSURL URLWithString:str] forState:UIControlStateNormal];
    }
    //判断是否是自己发送
    if ([message.from isEqualToString:userName]) {//是本人发送
        [self setBtnImage:@"SenderTextNodeBkg"];
        NSString * iconUrl = [XQQManager sharedManager].iconURL;
        if ([iconUrl isEqualToString:@"1.jpg"]) {
            [self.rightChatIcon setImage:[UIImage imageNamed:iconUrl] forState:UIControlStateNormal];
        }else{
            [self.rightChatIcon sd_setImageWithURL:[NSURL URLWithString:iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        }
        //头像在右面
        self.leftChatIcon.hidden = YES;
        self.rightChatIcon.hidden = NO;
        self.rightChatIcon.frame = CGRectMake(iphoneWidth - boardWidth - allSubViewHeight,  _timeLabel.isHidden ? boardWidth : 20, allSubViewHeight, allSubViewHeight);
        
        //消息在左面
        //NSLog(@"%@",self.chatBtn.frame);
        
        self.chatBtn.xqq_left = iphoneWidth - self.chatBtn.frame.size.width - self.rightChatIcon.xqq_width - boardWidth * 2;
        
        self.chatBtn.xqq_top = self.rightChatIcon.xqq_top;
    }else{//好友发送
        [self setBtnImage:@"ReceiverTextNodeBkg"];
        self.rightChatIcon.hidden = YES;
        self.leftChatIcon.hidden = NO;
        
        //从数据库取当前聊天的好友信息
        //判断消息类型
        NSString * messageFrom = @"";
        if (message.messageType == eMessageTypeGroupChat) {
            messageFrom = message.groupSenderName;
        }else{
            messageFrom = message.from;
        }
        
        
        //服务器查询某个好友的信息(可以是当前用户的好友 也可以不是,存在群聊的情况)
//        [[XQQUserInfoTool sharedManager] getOneFriendInfo:messageFrom complete:^(NSArray *array, NSError *error) {
//            BmobObject * object = array[0];
//            NSString * iconURL = [object objectForKey:@"iconURL"];
//            if ([iconURL isEqualToString:@"1.jpg"]) {
//                [self.leftChatIcon setImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
//            }else{
//                [self.leftChatIcon sd_setImageWithURL:[NSURL URLWithString:iconURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1.jpg"]];
//            }
//        }];
        //下面是从本地数据库获取好友信息(消息的用户是当前登录的好友)
        NSDictionary * friendInfoDict = [[XQQDataManager sharedDataManager] searchFriend:messageFrom];
        NSString * iconURL = friendInfoDict[@"iconURL"];
        if ([iconURL isEqualToString:@"1.jpg"]) {
            [self.leftChatIcon setImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
        }else{
            [self.leftChatIcon sd_setImageWithURL:[NSURL URLWithString:iconURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        }
        //头像在左
        self.leftChatIcon.frame = CGRectMake(boardWidth, _timeLabel.isHidden ? boardWidth : 20, allSubViewHeight, allSubViewHeight);
        //消息在右面
        self.chatBtn.xqq_left = CGRectGetMaxX(self.leftChatIcon.frame) + boardWidth;
        self.chatBtn.xqq_top = self.leftChatIcon.xqq_top;
    }
    self.cellHeight = CGRectGetMaxY(self.chatBtn.frame) + 5;
}

- (void)setFriendModel:(XQQFriendModel *)friendModel{
    _friendModel = friendModel;
}
/*cell的高度*/
- (CGFloat)cellHeight{
    return self.chatBtn.xqq_bottom + 5;
}

+ (CGFloat)heightForRowWithModel:(EMMessage *)m
{
    CGFloat height = 0;
    //获取消息体
    id body = m.messageBodies[0];

    //判断消息类型
    
    CGSize chatBtnSize;
    
    if ([body isKindOfClass:[EMTextMessageBody class]]) {//文本类型
        EMTextMessageBody * textBody = body;
        
        CGSize btnSize = [textBody.text.attributedText boundingRectWithSize:CGSizeMake(iphoneWidth/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGSize realSize = CGSizeMake(btnSize.width + 40, btnSize.height + 30);
        chatBtnSize = realSize;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){//语音
        
        //设置图片和时间
        chatBtnSize = CGSizeMake(allSubViewHeight + 50, allSubViewHeight + 15);

    }else if ([body isKindOfClass:[EMImageMessageBody class]]){//图片

        //图片消息体
        EMImageMessageBody * imageMessageBody = body;
        
        //图片的size
        CGSize imageSize = imageMessageBody.thumbnailSize;

        //只存在两种图片形式
        CGFloat width = allSubViewHeight * 4 + 20;
        CGFloat height = allSubViewHeight * 2 + 50;
        
        if (imageSize.width - imageSize.height > 0) {//宽大于高 横着
            chatBtnSize = CGSizeMake(width,height);
        }else{//竖着
            chatBtnSize = CGSizeMake(height,width);
        }

    }else if ([body isKindOfClass:[EMLocationMessageBody class]]){//位置
        

        chatBtnSize = CGSizeMake(allSubViewHeight * 4 + 20, allSubViewHeight * 2 + 50);

    }
    
    return height;
}

- (void)setBtnImage:(NSString *)name{
    [self.chatBtn setBackgroundImage:[UIImage resizingImageWithName:name] forState:UIControlStateNormal];
    NSString *hightName = [NSString stringWithFormat:@"%@HL",name];
    [self.chatBtn setBackgroundImage:[UIImage resizingImageWithName:hightName] forState:UIControlStateHighlighted];
}
#pragma mark - get



@end
