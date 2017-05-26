//
//  XQQDetailCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/18.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQQDetailCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
/** 个人数据字典 */
@property(nonatomic, strong)  NSDictionary  *  infoDict;

@end
