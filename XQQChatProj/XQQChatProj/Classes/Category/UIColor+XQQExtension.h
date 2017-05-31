//
//  UIColor+XQQExtension.h
//  XQQChatProj
//
//  Created by xuqinqiang on 2017/5/31.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XQQExtension)
/**
 *  将十六进制数 转化为 UIColor
 *
 *  @param hexString 十六进制数
 *
 *  @return UIColor
 */
+ (UIColor *)xqq_colorWithHexString:(NSString *)hexString;

/**
 *  将十六进制数 转化为 UIColor
 *
 *  @param hexString 十六进制数
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor*)xqq_colorWithHexString:(NSString*)hexString andAlpha:(float)alpha;

/**
 *  获取颜色
 *
 *  @param red   红
 *  @param green 绿
 *  @param blue  蓝
 *
 *  @return 颜色
 */
+ (UIColor *)xqq_colorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue;

@end
