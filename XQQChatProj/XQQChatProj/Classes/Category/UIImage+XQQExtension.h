//
//  UIImage+XQQExtension.h
//  XQQChatProj
//
//  Created by xuqinqiang on 2017/5/31.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XQQExtension)
/** 改变图片大小 */
+ (UIImage *)resizingImageWithName:(NSString *)name;

/**
 *  剪裁图片
 *
 *  @param image 原图片
 *  @param inset 剪裁比例
 *
 *  @return 剪裁后图片
 */
+ (UIImage *)xqq_circleImage:(UIImage *)image withParam:(CGFloat)inset;

/**
 *  压缩图片
 *
 *  @param imgSrc 原图片
 *  @param size   压缩到的大小
 *
 *  @return 压缩后图片
 *
 */
+ (UIImage *)xqq_compressImage:(UIImage *)imgSrc compressToSize:(CGSize)size;

/**
 *  截屏
 *
 *  @return 返回图片
 */
+ (UIImage *)xqq_screenshot;

/**
 *  颜色转成图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage *)xqq_imageWithColor:(UIColor *)color;

/*  获取 app 启动图 */
+ (UIImage *)xqq_getAppLaunchImage;

/* 调整图片大小 */
- (UIImage *)xqq_TransformtoSize:(CGSize)Newsize;



@end
