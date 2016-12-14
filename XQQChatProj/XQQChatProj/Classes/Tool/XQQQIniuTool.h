//
//  XQQQIniuTool.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/21.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
#import "QiniuPutPolicy.h"

/**
 *  注册七牛获取
 */
static NSString *QiniuAccessKey        = @"BGr74ydsAVLK9IM-YqQy1ymzARLOsg3ev0XLmsIh";
static NSString *QiniuSecretKey        = @"wmYfDTaVssxzrfjwcdEPB_5Rfag8thTIfA3YrWWb";
static NSString *QiniuBucketName       = @"xqqfirst";
static NSString *QiniuBaseURL          = @"http://ogts0vmmj.bkt.clouddn.com/";

/*七牛存储管理类*/
@interface XQQQIniuTool : NSObject

/*管理实例*/
+ (instancetype)sharedManager;
/*上传图片*/
- (void)sendIconToQiniu:(UIImage*)image;

/*删除一张图片*/
- (void)deleteImageWithFormat:(NSString*)iconName
                      success:(void(^)(NSURLSessionDataTask * task ,id responseObject))successBlock
                    failBlock:(void(^)(NSURLSessionDataTask * task,NSError * error))failBlock;

@end
