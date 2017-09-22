//
//  UIFont+KDS_FontHandle.h
//  KDS_Phone
//
//  Created by HuChenRui on 16/3/22.
//  Copyright © 2016年 kds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (KDS_FontHandle)

/**
 *  创建UIFont对象 如果找到不的字体，则使用系统的
 *
 *  @param fontName
 *  @param fontSize
 *
 *  @return 对象
 */
+ (UIFont *)kds_fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

/**
 *  字体名称是否是苹方
 *
 *  @param fontName
 *
 *  @return 结果
 */
+ (BOOL)fontNamePingFang:(NSString *)fontName;

/**
 *  苹方字号要小两号
 *
 *  @param fontName
 *  @param bFontSize 非苹方的字号
 *
 *  @return 苹方字号
 */
+ (CGFloat)PingFangFontSize:(NSString *)fontName baseFontSize:(CGFloat)bFontSize;

@end
