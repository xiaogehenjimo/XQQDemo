//
//  XQQEssenceModel.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQEssenceModel.h"

static NSDateFormatter * fmt_;
static NSCalendar * calendar_;

@implementation XQQEssenceModel

+(void)initialize{
    fmt_ = [[NSDateFormatter alloc]init];
    //获得NSCalendar
    calendar_ = [NSCalendar calendar];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }else if ([key isEqualToString:@"top_cmt"]){//创建评论模型
        NSArray * dataArr = value;
        NSMutableArray * tmpArr = @[].mutableCopy;
        for (NSDictionary * obj in dataArr) {
            XQQCommentModel * commentModel = [[XQQCommentModel alloc]init];
            [commentModel setValuesForKeysWithDictionary:obj];
            [tmpArr addObject:commentModel];
        }
        _cmtArr = tmpArr;
    }
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

- (NSString *)created_at{
    //进行日期判断  2016-10-18 14:50:02
    fmt_.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * createAtDate = [fmt_ dateFromString:_created_at];
    
    if ([createAtDate isThisYear_XQQadd]) {//是今年
        if (createAtDate.isToday_XQQadd) {//是不是今天
            //当前时间
            NSDate * nowDate = [NSDate date];
            //获得两个日期之间的间隔
            NSCalendarUnit unit = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents * comps = [calendar_ components:unit fromDate:createAtDate toDate:nowDate options:0];
            if (comps.hour >= 1) {//时间间隔>=1小时
                return [NSString stringWithFormat:@"%zd小时前",comps.hour];
            }else if (comps.minute >= 1){//1小时>时间间隔>=1小时
                return [NSString stringWithFormat:@"%zd分钟前",comps.minute];
            }else{//1分钟>时间间隔
                return @"刚刚";
            }
        }else if (createAtDate.isYesterday_XQQadd){//昨天
            fmt_.dateFormat = @"昨天 HH:mm:ss";
            return [fmt_ stringFromDate:createAtDate];
        }else{//其他天
            fmt_.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt_ stringFromDate:createAtDate];
        }
    }else{//不是今年
        return _created_at;
    }
}

@end
