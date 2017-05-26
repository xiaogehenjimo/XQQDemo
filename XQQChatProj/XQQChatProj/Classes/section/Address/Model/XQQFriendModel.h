//
//  XQQFriendModel.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/22.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQQFriendModel : NSObject
/** 好友名字 */
@property (nonatomic, copy)  NSString  *  userName;
/** 好友是否在线 */
@property (nonatomic, assign)  BOOL  isOnline;
/** 好友昵称 */
@property (nonatomic, copy)  NSString  *  nickName;
/** 好友头像 */
@property (nonatomic, copy)  NSString  *  iconImgaeURL;

/** 是否是选中 (只在创建群的时候使用)*/
@property(nonatomic, assign)  BOOL   isSel;
@end
