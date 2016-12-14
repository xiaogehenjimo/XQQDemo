//
//  XQQAddressCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/17.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQFriendModel.h"
@interface XQQAddressCell : UITableViewCell
/** 好友模型 */
@property(nonatomic, strong)  XQQFriendModel  *  model;

+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexPath;
@end
