//
//  XQQPersionCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/18.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQQPersionCell : UITableViewCell
/*左侧显示的label*/
@property(nonatomic, strong)  UILabel * leftLabel;
/** 中间显示的label */
@property(nonatomic, strong)  UILabel  *  centerLabel;
/** 右侧的图片 */
@property(nonatomic, strong)  UIImageView  *  iconImageView;

+ (instancetype)cellForTableView:(UITableView*)tableView
                  rowAtIndexPath:(NSIndexPath*)inidexPath;

@end
