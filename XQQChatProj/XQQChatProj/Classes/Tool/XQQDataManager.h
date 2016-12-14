//
//  XQQDataManager.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "XQQFriendModel.h"
@interface XQQDataManager : NSObject

@property (nonatomic, strong) FMDatabase * db;

+ (instancetype)sharedDataManager;
/*获取数据库*/
- (void)GetDB;
/*创建数据库*/
- (void)createDataBaseWithUserName:(NSString*)userName;
/*创建个人信息表*/
- (void)createPersonInfoTableWithUserName:(NSString*)userName;
/*创建历史消息表*/
- (void)createTableWithStr:(NSString*)userName;
/*插入一条消息到数据库*/
- (void)insertMessage:(EMMessage*)message;



/*创建用户好友表*/
- (void)createUserFriendListWithUserName:(NSString*)userName;
/*插入一个好友到表里*/
- (void)insertNewFriendWithBody:(XQQFriendModel*)model;
/*删除一个好友*/
- (void)deleteFrinendWithFriendName:(NSString*)friendName;
/*从数据库读取所有好友*/
- (NSArray*)searchAllFriend;
/*查找某个用户*/
- (NSDictionary*)searchFriend:(NSString*)userName;
/*数据库表中是否存在这个好友*/
- (BOOL)searchFriendWithUserName:(NSString*)userName;
/*查看个人信息*/
- (NSArray*)searchCurrentPensonInfo;
/*更新个人信息表*/
- (void)updatePersonTable:(NSDictionary*)infoDict;
/*更新某个好友信息*/
- (void)updateFriendInfo:(XQQFriendModel*)model;

@end
