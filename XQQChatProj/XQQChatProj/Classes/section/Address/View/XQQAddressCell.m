//
//  XQQAddressCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/17.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQAddressCell.h"
#define boardWidth 10
@interface XQQAddressCell ()
/*头像*/
@property(nonatomic, strong)  UIImageView * iconImageView;
/** 名字 */
@property(nonatomic, strong)  UILabel     *  nameLabel;
/** 右侧状态信息 */
@property(nonatomic, strong)  UIView      *  statusView;


@end

@implementation XQQAddressCell

+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexPath{
    static NSString * cellID = @"addressCell";
    XQQAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XQQAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //65
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(boardWidth, boardWidth, 45, 45)];
        _iconImageView.layer.cornerRadius = 6;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.image = [UIImage imageNamed:@"1.jpg"];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + boardWidth, boardWidth + 5, iphoneWidth - 3 * boardWidth - 5 - _iconImageView.frame.size.width - 30, 30)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _statusView = [[UIView alloc]initWithFrame:CGRectMake(iphoneWidth - boardWidth - 30, boardWidth + 5, 30, 30)];
        _statusView.layer.cornerRadius = 15;
        _statusView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_statusView];
        
    }
    return self;
}

- (void)setModel:(XQQFriendModel *)model{
    _model = model;
    if ([model.nickName isEqualToString:@"暂未设置"]) {
        _nameLabel.text = model.userName;
    }else{
        _nameLabel.text = model.nickName;
    }
    //是否在线
    if (model.isOnline) {
        _statusView.backgroundColor = XQQColor(132, 193, 111);
    }else{
        _statusView.backgroundColor = XQQColor(246, 246, 246);
    }
    if ([model.iconImgaeURL isEqualToString:@"1.jpg"]) {
        _iconImageView.image = [UIImage imageNamed:model.iconImgaeURL];
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImgaeURL] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    }
}

@end
