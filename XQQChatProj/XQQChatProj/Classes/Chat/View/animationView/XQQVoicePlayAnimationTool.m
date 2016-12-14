//
//  XQQVoicePlayAnimationTool.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/25.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQVoicePlayAnimationTool.h"

@interface XQQVoicePlayAnimationTool ()

@property(nonatomic,strong)UIImageView * animationImageView;
/** 数据 */
@property(nonatomic, strong)  NSMutableArray  *  dataArr;

@end

@implementation XQQVoicePlayAnimationTool
+ (instancetype)sharedTool{
    static XQQVoicePlayAnimationTool * tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[XQQVoicePlayAnimationTool alloc]init];
    });
    return tool;
}
/*开始动画*/
- (void)startAnimationWithBtn:(XQQChatBtn*)button
                       isMine:(BOOL)isMine{
    if (self.animationImageView) {
        [self.animationImageView stopAnimating];
        [self.dataArr removeAllObjects];
        [self.animationImageView removeFromSuperview];
        self.animationImageView = nil;
    }
    self.animationImageView = [[UIImageView alloc]initWithFrame:button.imageView.frame];
    [button addSubview:self.animationImageView];
    if (isMine) {
        //本人发送
        for (NSInteger i = 1; i < 4; i ++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying00%ld",i]];
            [self.dataArr addObject:image];
        }
    }else{//好友发送
        for (NSInteger i = 1; i < 4; i ++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%ld",i]];
            [self.dataArr addObject:image];
        }
    }
    self.animationImageView.animationImages = self.dataArr;
    self.animationImageView.animationDuration = 1.0f;
    self.animationImageView.animationRepeatCount = 0;
    [self.animationImageView startAnimating];
}

/*停止动画*/
- (void)endAnimation{
    [self.animationImageView stopAnimating];
    [self.dataArr removeAllObjects];
    self.animationImageView = nil;
    [self.animationImageView removeFromSuperview];
}



- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

@end
