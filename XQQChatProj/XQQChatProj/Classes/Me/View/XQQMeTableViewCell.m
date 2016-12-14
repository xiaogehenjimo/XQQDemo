//
//  XQQMeTableViewCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQMeTableViewCell.h"

#define boardWidth 5
@interface XQQMeTableViewCell ()
/**左侧图片*/
@property(nonatomic, strong)  UIImageView * leftImageView;
/** 中间label*/
@property(nonatomic, strong)  UILabel     *  nameLabel;
/** 右侧的按钮 */
@property(nonatomic, strong)  UIButton    *  rightBtn;


@end

@implementation XQQMeTableViewCell
+ (instancetype)cellForTableView:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath{
    static NSString * cellID = @"SetCellID";
    XQQMeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XQQMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         //self.contentView.backgroundColor = XQQColor(250, 250, 250);
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3 *boardWidth, boardWidth + 5, 30, 30)];
        
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(iphoneWidth - boardWidth - 40, boardWidth, 40, 40)];
        _rightBtn.backgroundColor = XQQColor(255, 255, 255);
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame) + 3 * boardWidth, boardWidth, iphoneWidth - 4 * boardWidth - _leftImageView.frame.size.width - _rightBtn.frame.size.width, 40)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:_leftImageView];
        //[self.contentView addSubview:_rightBtn];
        //self.accessoryView = _rightBtn;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:_nameLabel];
    }//Mode_listarrow
    //Mode_listarrowHL
    return self;
}
- (void)setInfoModel:(XQQMeModel *)infoModel{
    _infoModel = infoModel;
    _leftImageView.image = [UIImage imageNamed:infoModel.image];
    _nameLabel.text = infoModel.name;
    [_rightBtn setImage:[[UIImage imageNamed:@"Mode_listarrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_rightBtn setImage:[[UIImage imageNamed:@"Mode_listarrowHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    _rightBtn.backgroundColor = [UIColor whiteColor];
}

@end
