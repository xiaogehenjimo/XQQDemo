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
 @param objects 多参数 如果是基础数据类型转成 NSNumber 不推荐@()
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
        
        for (NSInteger i = 0; i < count; i++) {
            
            id argument = objects[i];
            
            //这里要判断传入的参数是什么类型的 基础数据类型是包装成NSNumber 存入的数组
            
            [self judgeParamTypeWithSignature:signature
                                       parame:argument
                                   invocation:invocation
                                        index:i];
            
        }
    }
    
    //将传入的所有参数以及target都retain一遍
    [invocation retainArguments];
    
    //开始调用方法
    [invocation invoke];
    
    //返回值 要在函数调用之后 能得到这个方法的返回值 也支持手动设置 [invocation setReturnValue:anyValue];
    
    return (signature.methodReturnLength != 0) ? [self judgeTypeWithSignature:signature Invocation:invocation] : nil;
    
}

/**
 判断返回值类型
 
 @param signature  函数签名
 @param invocation 函数调用
 @return 返回值
 */
- (id)judgeTypeWithSignature:(NSMethodSignature*)signature
                  Invocation:(NSInvocation *)invocation{
    
    if (signature.methodReturnLength != 0) {
        
        const char * methodType = signature.methodReturnType;
        
        if(strcmp(methodType, @encode(float)) == 0){
            
            float returnVal;
            
            [invocation getReturnValue:&returnVal];
            
            return [NSNumber numberWithFloat:returnVal];
            
        }else if (strcmp(methodType, @encode(int)) == 0 || strcmp(methodType, @encode(NSInteger)) == 0 || strcmp(methodType, @encode(NSUInteger)) == 0){
            
            NSInteger returnVal;
            
            [invocation getReturnValue:&returnVal];
            
            return [NSNumber numberWithInteger:returnVal];
        }
        else if (strcmp(methodType, @encode(BOOL)) == 0){
            
            //it's an bool
            BOOL returnVal;
            
            [invocation getReturnValue:&returnVal];
            
            return [NSNumber numberWithBool:returnVal];
            
        }else if (strcmp(methodType, @encode(int32_t)) == 0 || strcmp(methodType, @encode(long)) == 0){
            
            //it's an long
            int32_t returnVal;
            
            [invocation getReturnValue:&returnVal];
            
            return [NSNumber numberWithLong:returnVal];
            
        }else if (strcmp(methodType, @encode(int64_t)) == 0 || strcmp(methodType, @encode(long long)) == 0){
            //it's an long long
            int64_t returnVal;
            
            [invocation getReturnValue:&returnVal];
            
            return [NSNumber numberWithLongLong:returnVal];
            
        }else if (strcmp(methodType, @encode(double)) == 0){
            //it's an double
            double returnVal;
            
            [invocation getReturnValue:&returnVal];
            
            return [NSNumber numberWithDouble:returnVal];
            
        }else{
            //it's some sort of object
            void *returnVal;
            
            [invocation getReturnValue:&returnVal];
            
            return (__bridge id)(returnVal);
        }
    }else{
        return nil;
    }
}


/**
 判断传入的参数类型
 
 @param parame     参数
 @param invocation 函数调用
 @param index      参数插入的序号
 */
- (void)judgeParamTypeWithSignature:(NSMethodSignature*)signature
                             parame:(id)parame
                         invocation:(NSInvocation*)invocation
                              index:(NSInteger)index{
    
    if ([parame isKindOfClass:[NSNumber class]]) {
        //传递过来的参数类型
        const char * type = [(NSNumber*)parame objCType];
        
        //方法需要传递的参数类型
        const char * methType = [signature getArgumentTypeAtIndex:index + 2];
        
        //判断传递过来的参数是不是bool类型  [NSNumber objCType] 返回的是'c' 而@encode(BOOL)返回的是 'B'
        BOOL isNext;
        
        if ((strcmp(type, "c") == 0) && strcmp(methType, "B") == 0) {
            //传入的参数和方法需要的参数 为bool
            isNext = YES;
            
        }else{
            //传入的参数和方法需要的参数 不是bool 是其他类型
            isNext = (strcmp(type, methType) == 0) ? YES : NO;
        }
        
        NSString * descStr = [NSString stringWithFormat:@"传入的参数与%@方法需要的参数类型不一致!",NSStringFromSelector(invocation.selector)];
        
        NSAssert(isNext, descStr);
        
        if(strcmp(methType, @encode(float)) == 0){
            
            float value = [parame floatValue];
            
            [invocation setArgument:&value atIndex:2 + index];
            
        }else if (strcmp(methType, @encode(int)) == 0 || strcmp(type, @encode(NSInteger)) == 0 || strcmp(type, @encode(NSUInteger)) == 0){
            
            NSInteger value = [parame integerValue];
            
            [invocation setArgument:&value atIndex:2 + index];
            
        }
        else if (strcmp(methType, @encode(BOOL)) == 0){
            
            //it's an bool
            BOOL value = [parame boolValue];
            
            [invocation setArgument:&value atIndex:2 + index];
            
        }else if (strcmp(methType, @encode(int32_t)) == 0 || strcmp(type, @encode(long)) == 0){
            
            //it's an long
            int32_t value = (int32_t)[parame longValue];
            
            [invocation setArgument:&value atIndex:2 + index];
            
        }else if (strcmp(methType, @encode(int64_t)) == 0 || strcmp(type, @encode(long long)) == 0){
            //it's an long long
            int64_t value = [parame longLongValue];
            
            [invocation setArgument:&value atIndex:2 + index];
            
        }else if (strcmp(methType, @encode(double)) == 0){
            //it's an double
            double value = [parame doubleValue];
            
            [invocation setArgument:&value atIndex:2 + index];
            
        }
        
    }else{
        [invocation setArgument:&parame atIndex:2 + index];
    }
}

@end
