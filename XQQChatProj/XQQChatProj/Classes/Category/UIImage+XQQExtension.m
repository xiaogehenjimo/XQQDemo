//
//  UIImage+XQQExtension.m
//  XQQChatProj
//
//  Created by xuqinqiang on 2017/5/31.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "UIImage+XQQExtension.h"

@implementation UIImage (XQQExtension)

+ (UIImage *)resizingImageWithName:(NSString *)name{
    
    UIImage *normalImg = [UIImage imageNamed:name];
    
    CGFloat w = normalImg.size.width * 0.5f;
    CGFloat h = normalImg.size.height * 0.5f;
    
    return [normalImg resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}
+ (UIImage *)xqq_circleImage:(UIImage *)image withParam:(CGFloat)inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)xqq_compressImage:(UIImage *)imgSrc compressToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

+ (UIImage *)xqq_screenshot {
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(screenWindow.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(screenWindow.bounds.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

+ (UIImage *)xqq_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)xqq_getAppLaunchImage {
    NSString *imgName = nil;
    if (iPhone6Plus) {
        imgName = @"LaunchImage-800-Portrait-736h@3x.png";
    } else if (iPhone6) {
        imgName = @"LaunchImage-800-667h@2x.png";
    } else if (iPhone5) {
        imgName = @"LaunchImage-568h@2x.png";
    } else {
        imgName = @"LaunchImage@2x.png";
    }
    UIImage *image = [UIImage imageNamed:imgName];
    if (!image) {
        image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    return image;
}

- (UIImage *)xqq_TransformtoSize:(CGSize)Newsize
{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContext(Newsize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, Newsize.width, Newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}
@end
