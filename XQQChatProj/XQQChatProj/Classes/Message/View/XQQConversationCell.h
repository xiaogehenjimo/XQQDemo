//
//  XQQConversationCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQConversationModel.h"
@interface XQQConversationCell : UITableViewCell

/** 聊天用户的model*/
@property(nonatomic, strong)  XQQConversationModel  *  model;

+ (instancetype)cellForTableView:(UITableView*)tableView
                  rowAtIndexPath:(NSIndexPath*)indexPath;
@end
