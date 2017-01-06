//
//  XQQManager.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQManager.h"

@implementation XQQManager
static NSMutableDictionary * _essenceDict;
+ (instancetype)sharedManager{

    static XQQManager * manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[XQQManager alloc]init];
        _essenceDict = [[NSMutableDictionary alloc]init];
    });
    return manager;
}

/*获取网络状态*/
- (NSString*)getNetStates{
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"wifi";
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = @"wifi";
            break;
        case ReachableViaWWAN:
            net = @"wwan";
            break;
        case NotReachable:
            net = @"无网络";
        default:
            break;
    }
    return net;
}
#pragma mark - setter&getter
/**获取maxtime*/
- (NSString*)getMaxtimeWithKey:(NSString*)key{
    
    return [_essenceDict objectForKey:key];;
}
/**更新字典*/
- (void)updateInfoDict:(NSDictionary*)infoDict
                   key:(NSString*)key{
    [_essenceDict setValue:infoDict[@"maxtime"] forKey:key];
}

/*获取当前控制器的window*/
- (UIWindow*)getWindow{
    return [[[UIApplication sharedApplication] delegate] window];
}

/*获取tabbarController*/
- (UITabBarController*)getTabBarControler{
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    //注意! 这里应该是登录之后才能执行这个方法
    return (UITabBarController*)window.rootViewController;
}

/*获取当前屏幕显示的viewcontroller*/
- (UIViewController *)getCurrentVC{
   
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

@end
