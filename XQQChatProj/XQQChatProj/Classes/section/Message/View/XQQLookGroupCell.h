//
//  XQQLookGroupCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/6.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQQLookGroupCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexPath;
/** 群组 */
@property(nonatomic, strong)  EMGroup  *  group;

@end
