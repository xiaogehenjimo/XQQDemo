//
//  NSDate+XQQExtension.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XQQExtension)
/**是否为今年*/
- (BOOL)isThisYear_XQQadd;
/**是否为今天*/
- (BOOL)isToday_XQQadd;
/**是否为昨天*/
- (BOOL)isYesterday_XQQadd;
/**是否为明天*/
- (BOOL)isTomorrow_XQQadd;
@end
