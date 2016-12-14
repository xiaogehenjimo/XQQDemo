//
//  UIBarButtonItem+XQQExtension.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XQQExtension)
/**UIBarButtonItem*/
+ (instancetype)itemWithImage:(NSString*)image
                   hightImage:(NSString*)heightImage
                       target:(id)target
                       action:(SEL)action;
@end
