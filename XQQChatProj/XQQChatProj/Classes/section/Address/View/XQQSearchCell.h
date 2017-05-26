//
//  XQQSearchCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/27.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQFriendModel.h"
@interface XQQSearchCell : UITableViewCell
/** 好友模型 */
@property(nonatomic, strong)  XQQFriendModel  *  model;
/** width */
@property(nonatomic, assign)  CGFloat   cellWidth;

+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexPath;

@end
