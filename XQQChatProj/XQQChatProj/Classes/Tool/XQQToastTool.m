//
//  XQQToastTool.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQToastTool.h"

@implementation XQQToastTool
+ (void)showToastWithStr:(NSString*)str
                    view:(UIView*)view{
    [view hideToast];
    [view makeToast:str duration:1.f position:@"center"];
}
@end
