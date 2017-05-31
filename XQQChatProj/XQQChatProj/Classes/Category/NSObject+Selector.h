//
//  NSObject+Selector.h
//  XQQLocalCache
//
//  Created by xuqinqiang on 2017/5/31.
//  Copyright © 2017年 徐勤强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Selector)


/**
 NSInvocation 执行方法

 @param selector 方法
 @param objects 多参数
 */
- (id)performSelector:(SEL)selector withObjects:(NSArray*)objects;






@end
