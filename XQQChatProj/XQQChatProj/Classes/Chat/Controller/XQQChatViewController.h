//
//  XQQChatViewController.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/16.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQFriendModel.h"
#import "XQQChatInputView.h"
@interface XQQChatViewController : UIViewController
/** 是否是群聊 */
@property(nonatomic, assign)  BOOL   isGroup;
/** 群组 */
@property(nonatomic, strong)  EMGroup  *  chatGroup;
/** 会话类型 单聊 群聊 */
@property(nonatomic, assign)  EMMessageType   messageType;
/** 好友信息的model */
@property(nonatomic, strong)  XQQFriendModel  *  model;
/** 会话 */
@property(nonatomic, strong)  EMConversation  *  chatConversation;
/*聊天输入框*/
@property(nonatomic, strong)  XQQChatInputView * inputView;
/** 图片消息 */
@property(nonatomic, strong)  EMMessage       *  imageMessage;

@end
