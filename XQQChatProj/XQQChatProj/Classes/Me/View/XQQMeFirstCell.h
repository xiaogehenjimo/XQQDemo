//
//  XQQMeFirstCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQMeModel.h"
@interface XQQMeFirstCell : UITableViewCell

/** 个人信息 */
@property(nonatomic, strong)  XQQMeModel  *  persionInfo;

+ (instancetype)cellForTableView:(UITableView*)tableView
                  rowAtIndexPath:(NSIndexPath*)inidexPath;
@end
