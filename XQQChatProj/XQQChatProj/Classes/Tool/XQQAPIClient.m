//
//  XQQAPIClient.m
//  XQQThinkProj
//
//  Created by XQQ on 16/10/10.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQAPIClient.h"
#define TIMEOUTINTERVAL 15
#import <AFNetworking.h>
@interface XQQAPIClient ()

@property(nonatomic,strong) AFHTTPSessionManager * sessionManage;

@end

@implementation XQQAPIClient

+ (id)sharedAPIClient{
    static XQQAPIClient * client = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        client = [[XQQAPIClient alloc]init];
    });
    return client;
}

- (AFHTTPSessionManager *)sessionManage{
    @synchronized (self) {
        if (!_sessionManage) {
            _sessionManage = [AFHTTPSessionManager manager];
            _sessionManage.responseSerializer = [AFHTTPResponseSerializer serializer];
            _sessionManage.requestSerializer.timeoutInterval = TIMEOUTINTERVAL;
        }
        return _sessionManage;
    }
}

- (void)sendRequestPath:(NSString*)path
                 params:(NSDictionary*)params
                headers:(NSDictionary*)headers
                 method:(NSString*)method
                success:(XQQAPISuccessBlock)successBlock
                failure:(XQQAPIFailurlBlock)failureBlock{
    path = [NSString stringWithFormat:@"%@%@",XQQCommonURL,path];
    [self sendRequestPath:path params:params headers:headers method:method asyn:YES success:successBlock failure:failureBlock ];
}
- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                headers:(NSDictionary *)headers
                 method:(NSString *)method
                   asyn:(BOOL)asyn
                success:(XQQAPISuccessBlock)successBlock
                failure:(XQQAPIFailurlBlock)failureBlock
{
    if(![[Reachability reachabilityForInternetConnection] isReachable])
    {
        NSError *error = [NSError errorWithDomain:@"com.xqq" code:30301 userInfo:[NSDictionary dictionaryWithObject:@"当前网络不可用，请检查网络设置" forKey:@"NSLocalizedDescriptionKey"]];
        self.networkStatus = 0;
        if(failureBlock)
        {
            failureBlock(error);
            return;
        }
    }else{
        self.networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    }
    
    if ([method isEqualToString:@"GET"])
    {
        [self sendGETRequestWithPath:path parameters:params success:successBlock failure:failureBlock];
    }else if ([method isEqualToString:@"POST"])
    {
        [self sendPOSTRequestWithPath:path parameters:params success:successBlock failure:failureBlock];
    }
    
}
- (void)sendGETRequestWithPath:(NSString *)path
                    parameters:(NSDictionary *)params
                       success:(XQQAPISuccessBlock)successBlock
                       failure:(XQQAPIFailurlBlock)failureBlock
{
    [self.sessionManage GET:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        successBlock(json);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureBlock && error)
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"当前网络不可用，请检查网络设置" forKey:@"NSLocalizedDescriptionKey"];
            error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            failureBlock(error);
        }
    }];
}
- (void)sendPOSTRequestWithPath:(NSString *)path
                     parameters:(NSDictionary *)params
                        success:(XQQAPISuccessBlock)successBlock
                        failure:(XQQAPIFailurlBlock)failureBlock
{
    
    [self.sessionManage POST:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        successBlock(json);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureBlock && error)
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"当前网络不可用，请检查网络设置" forKey:@"NSLocalizedDescriptionKey"];
            error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            failureBlock(error);
        }
    }];
}

#pragma mark - API
/**获取我的页面的列表*/
- (void)getMeListWithMethod:(NSString *)method
                    success:(XQQAPISuccessBlock)successBlock
                    failure:(XQQAPIFailurlBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"square";
    params[@"c"] = @"topic";
    [self sendRequestPath:@""
                   params:params
                  headers:nil
                   method:method
                  success:successBlock
                  failure:failureBlock];
}
/**获取精华页面的列表*/
- (void)getEssenceListWithMethod:(NSString *)method
                         maxtime:(NSString*)maxtime
                            type:(NSString*)type
                         success:(XQQAPISuccessBlock)successBlock
                         failure:(XQQAPIFailurlBlock)failureBlock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"client"] = @"iphone";
    params[@"jbk"] = @"0";
    if (maxtime == nil || [maxtime isEqualToString:@""]) {
        
    }else{
        params[@"maxtime"] = maxtime;
    }
    //params[@"openudid"] = @"19deb9dde5ccf65fe1623b59a5ebeff55bcbc319";
    
    if (type == nil || [type isEqualToString:@""]) {
        
    }else{
        params[@"type"] = type;
    }
    [self sendRequestPath:@""
                   params:params
                  headers:nil
                   method:method
                  success:successBlock
                  failure:failureBlock];
}

@end
