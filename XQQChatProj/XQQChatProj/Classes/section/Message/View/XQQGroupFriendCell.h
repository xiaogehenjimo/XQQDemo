//
//  XQQGroupFriendCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/2.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XQQGroupFriendCell;
@class XQQFriendModel;
typedef void(^cellDidSelected)(XQQFriendModel * friendModel,BOOL isSel);

@interface XQQGroupFriendCell : UITableViewCell

/** 按钮选中的block */
@property (nonatomic, copy) cellDidSelected   didSelected;
/** 数据model */
@property(nonatomic, strong)   XQQFriendModel *  model;

+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexParh;

@end
