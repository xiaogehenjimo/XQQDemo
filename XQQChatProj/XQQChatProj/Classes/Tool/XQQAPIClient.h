//
//  XQQAPIClient.h
//  XQQThinkProj
//
//  Created by XQQ on 16/10/10.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
typedef void (^XQQAPISuccessBlock)(id respondObject);
typedef void (^XQQAPIFailurlBlock)(NSError * error);

@interface XQQAPIClient : NSObject

@property (nonatomic,assign) NetworkStatus networkStatus;
//获取实例
+ (id)sharedAPIClient;


/**获取我的页面的列表*/
- (void)getMeListWithMethod:(NSString *)method
                    success:(XQQAPISuccessBlock)successBlock
                    failure:(XQQAPIFailurlBlock)failureBlock;

/**获取精华页面的列表*/
- (void)getEssenceListWithMethod:(NSString *)method
                         maxtime:(NSString*)maxtime
                            type:(NSString*)type
                    success:(XQQAPISuccessBlock)successBlock
                    failure:(XQQAPIFailurlBlock)failureBlock;
@end
