//
//  UIView+XQQAdd.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XQQAdd)

@property (nonatomic, assign) CGFloat xqq_left;

@property (nonatomic, assign) CGFloat xqq_top;

@property (nonatomic, assign) CGFloat xqq_right;

@property (nonatomic, assign) CGFloat xqq_bottom;

@property (nonatomic, assign) CGFloat xqq_width;

@property (nonatomic, assign) CGFloat xqq_height;

@property (nonatomic, assign) CGFloat xqq_centerX;

@property (nonatomic, assign) CGFloat xqq_centerY;

@property (nonatomic, assign) CGPoint xqq_origin;

@property (nonatomic, assign) CGSize  xqq_size;

@property (nonatomic, assign) CGFloat xqq_x;

@property (nonatomic, assign) CGFloat xqq_y;



- (void)showToastWithStr:(NSString*)str;

- (void)removeAllSubviews;
@end
