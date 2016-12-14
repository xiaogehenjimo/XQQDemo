//
//  XQQChatModel.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/16.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatModel.h"
#import <UIButton+WebCache.h>
#define boardWidth 10
#define allSubViewHeight 44
@implementation XQQChatModel


- (void)setRecodeMessage:(EMMessage *)recodeMessage{
    _recodeMessage = recodeMessage;
    //拿到当前的登录用户
    NSString * userName = [XQQManager sharedManager].userName;
    //NSString * username = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    //获取消息体
    id body = recodeMessage.messageBodies[0];
    //当前消息前面的一条消息
    NSArray * befordArr = [self.conversation loadNumbersOfMessages:1 withMessageId:recodeMessage.messageId];
    EMMessage * latestMessage;
    if (befordArr.count > 0) {
        latestMessage = befordArr[0];
    }
    //计算两个时间间隔  如果大于2分钟 显示消息时间
    NSString * timeStr = [[XQQMessageTool sharedMessageTool] calculateTimeNewMessageTime:recodeMessage.timestamp oldTime:latestMessage.timestamp];
    if ([timeStr isEqualToString:@""]) {
        self.timeLabel.text = @"";
        self.timeLabel.hidden = YES;
        //没有
    }else{
        //有
        self.timeLabel.text = timeStr;
        self.timeLabel.hidden = NO;
    }
    //判断消息类型
    if ([body isKindOfClass:[EMTextMessageBody class]]) {//文本类型
        EMTextMessageBody * textBody = body;
        self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.chatBtn setTitle:textBody.text forState:UIControlStateNormal];
        [self.chatBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        CGSize btnSize = [textBody.text boundingRectWithSize:CGSizeMake(iphoneWidth/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        CGSize realSize = CGSizeMake(btnSize.width + 40, btnSize.height + 30);
        self.chatBtn.xqq_size = realSize;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){//语音
        EMVideoMessageBody * voiceBody = body;
        //设置图片和时间
        [self.chatBtn setTitle:[NSString stringWithFormat:@"%zd'",voiceBody.duration] forState:UIControlStateNormal];
        self.chatBtn.xqq_size = CGSizeMake(allSubViewHeight + 50, allSubViewHeight + 15);
        if ([recodeMessage.from isEqualToString:userName]) {//本人发送的
            ////SenderVoiceNodePlaying   talk1_ic_voice
            [self.chatBtn setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"] forState:UIControlStateNormal];
            //图片在右面
            self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(0,40,0,0);
            self.chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-20,0,self.chatBtn.imageView.frame.size.width);
        }else{//好友发送的
            //ReceiverVoiceNodePlaying talk2_ic_voice
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
        NSString * path = imageMessageBody.thumbnailLocalPath;
        NSFileManager * fileMgr = [NSFileManager defaultManager];
        NSURL * url = [fileMgr fileExistsAtPath:path] ? [NSURL fileURLWithPath:path] : [NSURL URLWithString:imageMessageBody.thumbnailRemotePath];
        [self.chatBtn sd_setImageWithURL:url forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGSize size = image.size;
            self.chatBtn.xqq_size = CGSizeMake(size.width  + 20, size.height  + 20);
        }];
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
        //拼接百度参数
        NSString * tmpStr = @"http://api.map.baidu.com/staticimage/v2?ak=KGMQ34ZLmyu3pkzXV84jD9sheailt2N6&mcode=UIP.XQQHXProj&center=%.7f,%.7f&width=300&height=200&zoom=16&markers=%.7f,%.7f";
        NSString * str = [NSString stringWithFormat:tmpStr,locationBody.longitude,locationBody.latitude,locationBody.longitude,locationBody.latitude];
        self.chatBtn.xqq_size = CGSizeMake(allSubViewHeight * 4 + 20, allSubViewHeight * 2 + 50);
        [self.chatBtn sd_setImageWithURL:[NSURL URLWithString:str] forState:UIControlStateNormal];
    }
    //判断是否是自己发送
    if ([recodeMessage.from isEqualToString:userName]) {//是本人发送
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
        self.chatBtn.xqq_left = iphoneWidth - self.chatBtn.xqq_width - self.rightChatIcon.xqq_width - boardWidth * 2;
        
        self.chatBtn.xqq_top = self.rightChatIcon.xqq_top;
    }else{//好友发送
        [self setBtnImage:@"ReceiverTextNodeBkg"];
        self.rightChatIcon.hidden = YES;
        self.leftChatIcon.hidden = NO;
        //从数据库取当前聊天的好友信息
        NSDictionary * friendInfoDict = [[XQQDataManager sharedDataManager] searchFriend:recodeMessage.from];
        
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

- (void)setBtnImage:(NSString *)name{
    [self.chatBtn setBackgroundImage:[UIImage resizingImageWithName:name] forState:UIControlStateNormal];
    NSString *hightName = [NSString stringWithFormat:@"%@HL",name];
    [self.chatBtn setBackgroundImage:[UIImage resizingImageWithName:hightName] forState:UIControlStateHighlighted];
}
@end
