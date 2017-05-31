//
//  NSObject+Selector.m
//  XQQLocalCache
//
//  Created by xuqinqiang on 2017/5/31.
//  Copyright © 2017年 徐勤强. All rights reserved.
//

#import "NSObject+Selector.h"

@implementation NSObject (Selector)

/**
 NSInvocation 执行方法
 
 @param selector 方法
 @param objects 多参数
 */
- (id)performSelector:(SEL)selector withObjects:(NSArray*)objects{

    if (!selector) return nil;
    
    NSMethodSignature * signature = [[self class] instanceMethodSignatureForSelector:selector];
    
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = self;
    
    invocation.selector = selector;
    
    //invocation 有两个隐藏参数 一个是target 一个是 selector 所以从2 开始
    if ([objects isKindOfClass:[NSArray class]]) {
        NSInteger count = MIN(objects.count, signature.numberOfArguments - 2);
        
        for (int i = 0; i < count; i++) {
            
            id argument = objects[i];
            
            [invocation setArgument:&argument atIndex:2 + i];
            
        }
    }
    [invocation retainArguments];
    //开始调用方法
    [invocation invoke];
    
    //返回值 要在函数调用之后 能得到这个方法的返回值 返回值 也支持手动设置 [invocation setReturnValue:anyValue];
    id returnVal;
    
    if (signature.methodReturnLength != 0) {
        [invocation getReturnValue:&returnVal];
    }
    
    return returnVal;
    
}




@end
