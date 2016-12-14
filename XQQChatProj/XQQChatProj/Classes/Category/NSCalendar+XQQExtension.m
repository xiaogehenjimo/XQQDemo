//
//  NSCalendar+XQQExtension.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "NSCalendar+XQQExtension.h"

@implementation NSCalendar (XQQExtension)
+ (instancetype)calendar{
    
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }else{
        return [NSCalendar currentCalendar];
    }
}
@end
