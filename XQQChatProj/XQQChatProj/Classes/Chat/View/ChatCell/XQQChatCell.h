//
//  XQQChatCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/24.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQChatBtn.h"
#import "XQQFriendModel.h"
@interface XQQChatCell : UITableViewCell
/** 这条会话 */
@property(nonatomic, strong)  EMConversation  *  conversation;
/** 聊天的 */
@property(nonatomic, strong)  XQQChatBtn  *  chatBtn;
/*当前聊天的好友信息*/
@property(nonatomic, strong)  XQQFriendModel  *  friendModel;
/** 消息 */
@property(nonatomic, strong)  EMMessage  *  message;
/** cell高度 */
@property(nonatomic, assign)  CGFloat   cellHeight;

+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexPath;
+ (CGFloat)heightForRowWithModel:(EMMessage *)m;

@end
