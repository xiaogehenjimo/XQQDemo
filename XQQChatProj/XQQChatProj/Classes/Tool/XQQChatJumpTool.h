//
//  XQQChatJumpTool.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/29.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XQQChatBtn.h"
#import "XQQChatViewController.h"
@interface XQQChatJumpTool : NSObject

+ (instancetype)sharedTool;
/*处理点击的消息*/
- (void)disposeMessage:(EMMessage*)message
                    vc:(XQQChatViewController*)vc
                button:(XQQChatBtn*)button;


@end
