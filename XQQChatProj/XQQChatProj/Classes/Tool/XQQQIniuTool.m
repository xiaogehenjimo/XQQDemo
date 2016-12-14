//
//  XQQQIniuTool.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/21.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQQIniuTool.h"
#import "UIImage-Extensions.h"
#import <AFNetworking.h>
@implementation XQQQIniuTool
/*管理实例*/
+ (instancetype)sharedManager{
    static XQQQIniuTool * tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[XQQQIniuTool alloc]init];
    });
    return tool;
    
}

- (NSData *)Base_HmacSha1:(NSString *)key data:(NSString *)data{
         const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
         const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
         //Sha256:
         // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
         //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
         //sha1
         unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
         CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
         NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
         //将加密结果进行一次BASE64编码。
         //NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return HMAC;
}

/*删除一张图片*/
- (void)deleteImageWithFormat:(NSString*)iconName
                      success:(void(^)(NSURLSessionDataTask * task ,id responseObject))successBlock
                    failBlock:(void(^)(NSURLSessionDataTask * task,NSError * error))failBlock{
    NSString * deleteKey = [NSString stringWithFormat:@"%@:%@",@"xqqfirst",iconName];
    NSString * EncodedEntryURI = [QNUrlSafeBase64 encodeString:deleteKey];
    NSString * postURL = [NSString stringWithFormat:@"http://rs.qiniu.com/delete/%@",EncodedEntryURI];
    NSMutableString * sigStr = [[NSMutableString alloc]initWithString:@"/delete/"];
    [sigStr appendString:EncodedEntryURI];
    [sigStr appendFormat:@"\n"];
    NSData * sign = [self Base_HmacSha1:@"wmYfDTaVssxzrfjwcdEPB_5Rfag8thTIfA3YrWWb" data:sigStr];
    NSString * encodeSign  = [QNUrlSafeBase64 encodeData:sign];
    NSString * accessToken = [NSString stringWithFormat:@"%@:%@",@"BGr74ydsAVLK9IM-YqQy1ymzARLOsg3ev0XLmsIh",encodeSign];
    NSString * AuthorizationStr = [NSString stringWithFormat:@"QBox %@",accessToken];
    AFHTTPRequestSerializer * res = [[AFHTTPRequestSerializer alloc]init];
    [res setValue:AuthorizationStr forHTTPHeaderField:@"Authorization"];
    [res setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = res;
    [manager POST:postURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        successBlock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(task,error);
    }];
}

/*获取上传图片token*/
- (NSString *)tokenWithScope:(NSString *)scope
{
    QiniuPutPolicy *policy = [QiniuPutPolicy new];
    policy.scope = scope;
    return [policy makeToken:QiniuAccessKey secretKey:QiniuSecretKey];
    
}
/*上传图片*/
- (void)sendIconToQiniu:(UIImage*)image{
    UIImage *originImage = image;
    CGSize cropSize;
    cropSize.width = 180;
    cropSize.height = cropSize.width * originImage.size.height / originImage.size.width;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    originImage = [originImage imageByScalingToSize:cropSize];
    
    NSData *imageData = UIImageJPEGRepresentation(originImage, 0.9f);
    
    //NSString *uniqueName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:date]];
    //当前登录的用户名
    NSString * currentUserName = [XQQManager sharedManager].userName;
    
    NSString *uniqueName = [NSString stringWithFormat:@"%@%@.jpg",currentUserName,[formatter stringFromDate:date]];
    
    NSString *uniquePath = [kDocumentsPath stringByAppendingPathComponent:uniqueName];
    
    //NSLog(@"uniquePath: %@",uniquePath);
    
    [imageData writeToFile:uniquePath atomically:NO];
    NSString *token = [self tokenWithScope:QiniuBucketName];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    
    NSString *key = [NSURL fileURLWithPath:uniquePath].lastPathComponent;
    
    QNUploadOption * opt = [[QNUploadOption alloc]initWithMime:nil progressHandler:^(NSString *key, float percent) {
        
    } params:@{@"x:foo":@"fooval"} checkCrc:YES cancellationSignal:nil];
    
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (!info.error) {
            NSString * contentURL = [NSString stringWithFormat:@"%@%@",QiniuBaseURL,key];
            XQQLog(@"文件上传成功 URL= %@",contentURL);
            //这里需要更新个人信息
            [XQQManager sharedManager].iconURL = contentURL;
            [[XQQUserInfoTool sharedManager] changeUserIcon:contentURL];
        }else{
            XQQLog(@"%@",info.error);
        }
    } option:opt];
}

@end
