//
//  XQQChatBtn.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/24.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQQChatBtn;
typedef void(^XQQButtonClickBlock)(XQQChatBtn *);
typedef void(^XQQButtonLongPress)(XQQChatBtn *);
@interface XQQChatBtn : UIButton

/** 回调 */
@property (nonatomic, copy)  XQQButtonClickBlock  block;
/** 按钮长按手势 */
@property (nonatomic, copy)  XQQButtonLongPress  longPressBlock;

+ (instancetype)createXQQButton;

@end
