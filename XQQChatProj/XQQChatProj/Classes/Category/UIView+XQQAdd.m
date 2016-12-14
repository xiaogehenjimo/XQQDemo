//
//  UIView+XQQAdd.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "UIView+XQQAdd.h"

@implementation UIView (XQQAdd)
- (CGFloat)xqq_left {
    return self.frame.origin.x;
}

- (void)setXqq_left:(CGFloat)xqq_left{
    CGRect frame = self.frame;
    frame.origin.x = xqq_left;
    self.frame = frame;
}

- (CGFloat)xqq_top {
    return self.frame.origin.y;
}

- (void)setXqq_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)xqq_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setXqq_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)xqq_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setXqq_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)xqq_width {
    return self.frame.size.width;
}

- (void)setXqq_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)xqq_height {
    return self.frame.size.height;
}

- (void)setXqq_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)xqq_centerX {
    return self.center.x;
}

- (void)setXqq_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)xqq_centerY {
    return self.center.y;
}

- (void)setXqq_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)xqq_origin {
    return self.frame.origin;
}

- (void)setXqq_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (void)setXqq_x:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setXqq_y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)xqq_x
{
    return self.frame.origin.x;
}

- (CGFloat)xqq_y
{
    return self.frame.origin.y;
}

- (CGSize)xqq_size {
    return self.frame.size;
}

- (void)setXqq_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)showToastWithStr:(NSString*)str{
    [self hideToast];
    [self makeToast:str duration:1.f position:@"center"];
}
- (void)removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}
@end
