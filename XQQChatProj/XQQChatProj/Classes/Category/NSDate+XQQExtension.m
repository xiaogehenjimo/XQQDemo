//
//  NSDate+XQQExtension.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "NSDate+XQQExtension.h"

@implementation NSDate (XQQExtension)
//- (BOOL)isThisYear_XQQadd{
//    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
//    fmt.dateFormat = @"yyyy";
//    NSString * selfYear = [fmt stringFromDate:self];
//    NSString * nowYear = [fmt stringFromDate:[NSDate date]];
//    return [selfYear isEqualToString:nowYear];
//}
- (BOOL)isThisYear_XQQadd{
    NSCalendar * calendar = [NSCalendar calendar];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    return selfYear == nowYear;
}
///**是否为今天*/
//- (BOOL)isToday_XQQadd{
//    NSCalendar * calendar = [NSCalendar calendar];
//    NSCalendarUnit unit = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateComponents  * selfCom = [calendar components:unit fromDate:self];
//    NSDateComponents  * nowCom =  [calendar components:unit fromDate:self];
//    return selfCom.year == nowCom.year &&selfCom.month == nowCom.month&&selfCom.day == nowCom.day;
//}
/**是否为今天*/
- (BOOL)isToday_XQQadd{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString * selfToday = [fmt stringFromDate:self];
    NSString * nowToday = [fmt stringFromDate:[NSDate date]];
    return [selfToday isEqualToString:nowToday];
}
/**是否为昨天*/
- (BOOL)isYesterday_XQQadd{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString * selfString = [fmt stringFromDate:self];
    NSString * nowString = [fmt stringFromDate:[NSDate date]];
    NSDate * selfDate = [fmt dateFromString:selfString];
    NSDate * nowfDate = [fmt dateFromString:nowString];
    NSCalendar * calendar = [NSCalendar calendar];
    NSCalendarUnit unit = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents * coms = [calendar components:unit fromDate:selfDate toDate:nowfDate options:0];
    return coms.year == 0&&coms.month == 0 &&coms.day == 1;
}
/**是否为明天*/
- (BOOL)isTomorrow_XQQadd{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString * selfString = [fmt stringFromDate:self];
    NSString * nowString = [fmt stringFromDate:[NSDate date]];
    NSDate * selfDate = [fmt dateFromString:selfString];
    NSDate * nowfDate = [fmt dateFromString:nowString];
    NSCalendar * calendar = [NSCalendar calendar];
    NSCalendarUnit unit = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents * coms = [calendar components:unit fromDate:selfDate toDate:nowfDate options:0];
    return coms.year == 0&&coms.month == 0 &&coms.day == -1;
}
@end
