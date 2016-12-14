//
//  XQQUserInfoTool.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/21.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock) (NSArray * array,NSError * error);
/*bmob网络数据库管理类*/
@interface XQQUserInfoTool : NSObject

+ (instancetype)sharedManager;
/*添加一个用户*/
- (void)addUser:(NSString*)user;
/*修改用户个人头像*/
- (void)changeUserIcon:(NSString*)iconURl;
/*修改个人昵称*/
- (void)changeNickName:(NSString*)nickName;
/*block方式获取所有好友的个人信息*/
- (void)getFriendPersionInfo:(NSArray*)list
                    complete:(void(^)(NSArray *array, NSError *error))complete;
/*获取好友的个人信息*/
- (void)getfriendPersionInfo:(NSArray*)list;
/*获取某个好友的信息*/
- (void)getFriendInfo:(NSString*)userName;
/*block方式查询好友信息*/
- (void)getOneFriendInfo:(NSString*)userName
                complete:(void(^)(NSArray *array, NSError *error))complete;
/*获取当前登录用户的个人信息*/
- (void)getMyInfo;
/*block方式获取当前登录用户的个人信息*/
- (void)getMyInfoComplete:(void(^)(NSArray *array, NSError *error))complete;
/*改变当前的状态是否在线*/
- (void)changeMyStates:(BOOL)isOnline;

@end
