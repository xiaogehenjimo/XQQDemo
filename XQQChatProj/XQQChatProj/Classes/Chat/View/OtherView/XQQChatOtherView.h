//
//  XQQChatOtherView.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol otherBtnDidPressDelegate <NSObject>

@optional
- (void)BtnDidPress:(NSInteger)btnTag;


@end

//各类选项的View
@interface XQQChatOtherView : UIView

/** 代理 */
@property(nonatomic, weak)  id<otherBtnDidPressDelegate>   delegate;

@end
