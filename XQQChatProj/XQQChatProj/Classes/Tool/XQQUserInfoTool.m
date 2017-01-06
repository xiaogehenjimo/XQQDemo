//
//  XQQUserInfoTool.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/21.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQUserInfoTool.h"

@implementation XQQUserInfoTool
+ (instancetype)sharedManager{
    static XQQUserInfoTool * tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[XQQUserInfoTool alloc]init];
    });
    return tool;
}
/*添加一个用户*/
- (void)addUser:(NSString*)user{
    //往ChatUser表添加一个用户   除了用户名 其他都是初始值
    BmobObject *gameScore = [BmobObject objectWithClassName:@"ChatUser"];
    [gameScore setObject:user forKey:@"userName"];
    [gameScore setObject:@"1.jpg" forKey:@"iconURL"];//默认头像
    [gameScore setObject:@"暂未设置" forKey:@"nickName"];
    [gameScore setObject:[NSNumber numberWithBool:NO] forKey:@"isOnline"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        if (isSuccessful) {//创建网络数据库
            XQQLog(@"网络数据库添加表成功%@",gameScore);
            [XQQManager sharedManager].objectID = gameScore.objectId;
        }else{
            XQQLog(@"网络数据库添加表失败");
        }
    }];
}


/*根据昵称查询用户信息*/
- (void)getUserInfoWithNickName:(NSString*)nickName
                       complete:(void(^)(NSArray *array, NSError *error))complete{
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"nickName" equalTo:nickName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            complete(array,error);
    }];
}




/*block方式查询好友信息*/
- (void)getOneFriendInfo:(NSString*)userName
                complete:(void(^)(NSArray *array, NSError *error))complete{
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"userName" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            complete(array,error);
    }];
}

/*获取某个好友的信息*/
- (void)getFriendInfo:(NSString*)userName{
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"userName" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0 ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XQQNoticGetFriendInfo object:array];
        }
    }];
}

/*block方式获取所有好友的个人信息*/
- (void)getFriendPersionInfo:(NSArray*)list
                    complete:(void(^)(NSArray *array, NSError *error))complete{
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"userName" containedIn:list];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0 ) {
            complete(array,error);
        }
    }];
}

/*获取好友的个人信息*/
- (void)getfriendPersionInfo:(NSArray*)list{
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"userName" containedIn:list];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0 ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XQQNoticFriendList object:array];
        }
    }];
}

/*block方式获取当前登录用户的个人信息*/
- (void)getMyInfoComplete:(void(^)(NSArray *array, NSError *error))complete{
    NSString * userName = [XQQManager sharedManager].userName;
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"userName" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            complete(array,error);
        }
    }];
}

/*获取当前登录用户的个人信息*/
- (void)getMyInfo{
    NSString * userName = [XQQManager sharedManager].userName;
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"userName" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XQQNoticPersonInfo object:array];
        }
    }];
}

/*修改个人昵称*/
- (void)changeNickName:(NSString*)nickName{
    //用户名
    NSString * userName = [XQQManager sharedManager].userName;
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"userName" equalTo:userName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            BmobObject * gameScore = array.firstObject;
            [gameScore setObject:nickName forKey:@"nickName"];
            
            [gameScore updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [SVProgressHUD showSuccessWithStatus:@"更新昵称成功"];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"更新昵称失败"];
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"查找用户失败"];
        }
    }];
}

/*修改用户个人头像*/
- (void)changeUserIcon:(NSString*)iconURl{
    //用户名
    NSString * userName = [XQQManager sharedManager].userName;
    //图片地址
    NSString * imageURL = iconURl;
    
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"userName" equalTo:userName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            BmobObject * gameScore = array.firstObject;
            [gameScore setObject:imageURL forKey:@"iconURL"];
            
            [gameScore updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [SVProgressHUD showSuccessWithStatus:@"更新头像成功"];
                    
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"更新头像失败"];
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"查找用户失败"];
        }
    }];
}

/*改变当前的状态是否在线*/
- (void)changeMyStates:(BOOL)isOnline{
    //用户名
    NSString * userName = [XQQManager sharedManager].userName;
    BmobQuery * query = [BmobQuery queryWithClassName:@"ChatUser"];
    [query whereKey:@"userName" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            BmobObject * gameScore = array.firstObject;
            [gameScore setObject:[NSNumber numberWithBool:isOnline] forKey:@"isOnline"];
            [gameScore updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    XQQLog(@"更改状态成功");
                }else{
                    XQQLog(@"更改状态失败");
                }
            }];
        }else{
            XQQLog(@"查找用户失败");
        }
    }];
}

@end
