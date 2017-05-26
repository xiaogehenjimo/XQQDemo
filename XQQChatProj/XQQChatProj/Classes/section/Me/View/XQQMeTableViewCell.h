//
//  XQQMeTableViewCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQMeModel.h"
@interface XQQMeTableViewCell : UITableViewCell
/** 模型 */
@property(nonatomic, strong)  XQQMeModel  *  infoModel;
+ (instancetype)cellForTableView:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath;
@end
