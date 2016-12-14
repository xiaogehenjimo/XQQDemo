//
//  XQQChatJumpTool.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/29.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatJumpTool.h"
#import "XQQVoicePlayAnimationTool.h"
#import "MWPhotoBrowser.h"
#import "XQQDetailLocationController.h"
@implementation XQQChatJumpTool

+ (instancetype)sharedTool{
    static XQQChatJumpTool * tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[XQQChatJumpTool alloc]init];
    });
    return tool;
}

/*处理点击的消息*/
- (void)disposeMessage:(EMMessage*)message
                    vc:(XQQChatViewController*)vc
                button:(XQQChatBtn*)button{
    id body = message.messageBodies[0];
    if ([body isKindOfClass:[EMVoiceMessageBody class]]) {// 播放语音
        NSString * currentName = [XQQManager sharedManager].userName;
        if ([message.from isEqualToString:currentName]) {//自己
            [[XQQVoicePlayAnimationTool sharedTool] startAnimationWithBtn:button isMine:YES];
        }else{//好友
            [[XQQVoicePlayAnimationTool sharedTool] startAnimationWithBtn:button isMine:NO];
        }
        [self playVoice:body];
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
        //EMImageMessageBody *imageBody = body;
        // 显示大图片
        vc.imageMessage = message;
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:vc];
        [vc.navigationController pushViewController:browser animated:YES];
    }else if ([body isKindOfClass:[EMLocationMessageBody class]]){//位置
        EMLocationMessageBody * locationBody = body;
        XQQDetailLocationController * detailLocationVC = [[XQQDetailLocationController alloc]init];
        detailLocationVC.locationMessagebody = locationBody;
        [vc.inputView resignResponder];
        [vc.navigationController pushViewController:detailLocationVC animated:YES];
    }else if ([body isKindOfClass:[EMVideoMessageBody class]]){//视频
        
    }
}

/*播放语音*/
- (void)playVoice:(EMVoiceMessageBody *)body
{
    EMVoiceMessageBody *voiceBody = body;
    // 获取本地路径
    NSString *path = voiceBody.localPath;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    // 判断path是否存在
    // 如果是不存在
    if (![fileMgr fileExistsAtPath:path]) {
        // 从远程服务器获取地址
        path = voiceBody.remotePath;
    }
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:path completion:^(NSError *error) {
        if (!error) {
            [[XQQVoicePlayAnimationTool sharedTool] endAnimation];
        }
    }];
}
@end
