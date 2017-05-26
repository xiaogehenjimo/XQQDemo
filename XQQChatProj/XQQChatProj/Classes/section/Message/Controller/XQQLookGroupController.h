//
//  XQQLookGroupController.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/6.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dismissController)();
@interface XQQLookGroupController : UIViewController
/** 让导航栏控制器释放的block */
@property (nonatomic, copy)  dismissController dissmissVC;

@end
