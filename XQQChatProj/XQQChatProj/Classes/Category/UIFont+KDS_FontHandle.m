//
//  UIFont+KDS_FontHandle.m
//  KDS_Phone
//
//  Created by HuChenRui on 16/3/22.
//  Copyright © 2016年 kds. All rights reserved.
//

#import "UIFont+KDS_FontHandle.h"

@implementation UIFont (KDS_FontHandle)

+ (UIFont *)kds_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *font = nil;
    if (kSystem_Version_Less_Than(@"9.0") && [self fontNamePingFang:fontName]) {
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    }
    
    font = [UIFont fontWithName:fontName size:fontSize];
    if (!font) {
        return [UIFont systemFontOfSize:fontSize];
    }
    
    return font;
}

+ (BOOL)fontNamePingFang:(NSString *)fontName {
    
    return [fontName hasPrefix:@"PingFang"];
}

+ (CGFloat)PingFangFontSize:(NSString *)fontName baseFontSize:(CGFloat)bFontSize {
    BOOL bPingFang = [self fontNamePingFang:fontName];
    if (bPingFang) {
        bFontSize -= 2;
    }
    
    return bFontSize;
}
@end
