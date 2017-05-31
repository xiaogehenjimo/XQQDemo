//
//  UIColor+XQQExtension.m
//  XQQChatProj
//
//  Created by xuqinqiang on 2017/5/31.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "UIColor+XQQExtension.h"

@implementation UIColor (XQQExtension)

#pragma mark - Public
+ (UIColor *)xqq_colorWithHexString:(NSString *)hexString {
    return [UIColor xqq_colorWithHexString:hexString andAlpha:1.0];
}

+ (UIColor*)xqq_colorWithHexString:(NSString*)hexString andAlpha:(float)alpha {
    UIColor *col;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [UIColor colorWithHex:hexValue alpha:alpha];
    } else {
        col = [UIColor blackColor];
    }
    return col;
}

+ (UIColor *)xqq_colorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}




#pragma mark - Private
// 根据NSInteger获取颜色值
+ (UIColor *)colorWithHex:(NSInteger)hexValue {
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}
@end
