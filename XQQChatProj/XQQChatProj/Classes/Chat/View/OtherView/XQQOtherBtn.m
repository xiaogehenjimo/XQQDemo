//
//  XQQOtherBtn.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/28.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQOtherBtn.h"

@implementation XQQOtherBtn



- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect imageRect = CGRectMake(0, 0, contentRect.size.width, contentRect.size.height * 0.8);
    return imageRect;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect titleRect = CGRectMake(0,contentRect.size.height - contentRect.size.height * 0.1, contentRect.size.width, contentRect.size.height * 0.1);
    return titleRect;
}

@end
