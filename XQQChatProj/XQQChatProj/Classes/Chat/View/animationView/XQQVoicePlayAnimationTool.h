//
//  XQQVoicePlayAnimationTool.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/25.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQChatBtn.h"
@interface XQQVoicePlayAnimationTool : NSObject

+ (instancetype)sharedTool;
/*开始动画*/
- (void)startAnimationWithBtn:(XQQChatBtn*)button
                       isMine:(BOOL)isMine;
/*停止动画*/
- (void)endAnimation;
@end
