//
//  XQQChatModel.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/16.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EaseMobSDKFull/EaseMob.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface XQQChatModel : NSObject
/*接收到的消息体*/
@property(nonatomic, strong)  EMMessage * recodeMessage;
/** 这条会话 */
@property(nonatomic, strong)  EMConversation  *  conversation;
///** 聊天的 */
@property(nonatomic, strong)  XQQChatBtn  *  chatBtn;
/*当前聊天的好友信息*/
@property(nonatomic, strong)  XQQFriendModel  *  friendModel;
/*时间label*/
@property(nonatomic, strong)  UILabel     *  timeLabel;
/** 左头像 */
@property(nonatomic, strong)  XQQChatBtn  *  leftChatIcon;
/** 右头像 */
@property(nonatomic, strong)  XQQChatBtn  *  rightChatIcon;

/** frame */
@property(nonatomic, assign)  CGRect   btnFrame;
/** 中间消息的frame */
@property(nonatomic, assign)  CGSize   chatBtnSize;

/** <# class#> */
@property(nonatomic, assign)  CGFloat   cellHeight;


@end
