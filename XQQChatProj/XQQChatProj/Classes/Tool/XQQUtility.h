//
//  XQQUtility.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
@interface NSString (NSString_Extended)

- (NSString *)urlencode;

@end

@interface XQQUtility : NSObject
//序列化写入缓存
+ (void)archiveData:(NSArray *)array IntoCache:(NSString *)path;
+ (NSArray *)unarchiveDataFromCache:(NSString *)path;

+ (void)deleteArchiveDataWithPath:(NSString *)path;

+ (NSString *)hzTransferToPinYin:(NSString * )hanzi;
+(BOOL)stringIsAvailable:(NSString *)string;
+(BOOL)arrayIsAvailable:(NSArray *)array;

+ (BOOL)isStringPhoneNumberFormat:(NSString *)inputString;
+ (BOOL)isStringEmailFormat:(NSString *)inputString;
+ (BOOL)isStringChinese:(NSString *)inputString;

+ (void)setCookieInfo;

+ (NSString *)decryptUseDESLarge:(NSString *)cipherText key:(NSString *)key;
+ (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key;
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;

//通过手机号获取姓名
+ (NSString *)getTelephoneUserNameWithTelephone:(NSString *)telephone;

//职位浏览记录
+ (void)addJobLookRecordWithJob:(NSNumber *)jobId;
+ (BOOL)whetherJobLookedWithJob:(NSNumber *)jobId;

//计算文本高度
+ (CGSize)getTextHeightWithText:(NSString *)text
                           font:(UIFont *)font
                           size:(CGSize)size;

+ (CGSize)getTextHeightWithText:(NSString *)text
                           font:(UIFont *)font
                           size:(CGSize)size
                      lineSpace:(NSInteger)lineSpace;


//add by caiqian
//计算普通Label高度，加入折行方式
+ (CGSize)getTextHeightWithText:(NSString *)text
                           font:(UIFont *)font
                  lineBreakMode:(NSLineBreakMode)lineBreakMode
                           size:(CGSize)size;
//计算富文本高度
+ (CGSize)getTextHeightWithAttributedText:(NSAttributedString *)attributedString
                                     size:(CGSize)size
                            numberOfLines:(NSUInteger)numberOfLines;
//计算删除的人

+ (NSArray *)getDelegateContactorInAddressBook:(NSArray *)userList localSaved:(NSArray *)preUserList;

//计算添加的人

+ (NSArray *)getAddContactorInAddressBook:(NSArray *)userList localSaved:(NSArray *)preUserList;

+ (NSString *)DateWithString:(NSTimeInterval)messageDate;

+ (NSString *)LaunchImageName;
+ (void)showLaunchImageNameInView:(UIView *)view;

+ (NSString *)dateWithString:(NSTimeInterval)messageDate dateFormat:(NSString *)dateFormat;
+ (int)CheckNetworkStatus;

//身份证校验
+ (BOOL)verifyIDCardNumber:(NSString *)value;



@end
