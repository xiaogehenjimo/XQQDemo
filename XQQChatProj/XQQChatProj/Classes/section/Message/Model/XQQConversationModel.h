//
//  XQQConversationModel.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQQConversationModel : NSObject
/** 会话 */
@property(nonatomic, strong)  EMConversation  *  chatConversation;
/**好友名称*/
@property (nonatomic, copy)  NSString  *  chatter;
/**聊天的最后一条信息*/
@property (nonatomic, copy)  EMMessage  *  lastMessage;
/** 昵称 */
@property (nonatomic, copy)  NSString  *  nickName;
/** 头像链接 */
@property (nonatomic, copy)  NSString  *  iconURL;
/** 是否在线 */
@property(nonatomic, assign)  BOOL   isOnline;


@end
