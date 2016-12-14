//
//  XQQGroupFriendCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/2.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQGroupFriendCell.h"
#import "XQQFriendModel.h"
@interface XQQGroupFriendCell ()
/*左侧选择的按钮*/
@property(nonatomic, strong)  UIButton * selBtn;
/** 头像 */
@property(nonatomic, strong)  UIImageView  *  iconImageView;
/** 好友昵称 */
@property(nonatomic, strong)  UILabel  *  nickNameLabel;

@end

@implementation XQQGroupFriendCell

+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexParh{
    static NSString * cellID = @"groupFriend";
    XQQGroupFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XQQGroupFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _selBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 30, 30)];
        [_selBtn setImage:[UIImage imageNamed:@"CellNotSelected"] forState:UIControlStateNormal];
        [_selBtn setImage:[UIImage imageNamed:@"CellBlueSelected"] forState:UIControlStateSelected];

        _selBtn.layer.cornerRadius = 15;
        _selBtn.layer.masksToBounds = YES;
        [_selBtn addTarget:self action:@selector(selBtnDidpress:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_selBtn];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_selBtn.frame) + 10, 10, 50, 50)];
        _iconImageView.layer.cornerRadius = 4.0;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10, 20, iphoneWidth - 40 - _selBtn.xqq_width - _iconImageView.xqq_width, 30)];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.font = [UIFont systemFontOfSize:16];
        _nickNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nickNameLabel];
        UITapGestureRecognizer * sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap)];
        [self addGestureRecognizer:sigleTap];
    }
    return self;
}
/*cell点击了*/
- (void)viewTap{
    [_selBtn setSelected:!_selBtn.isSelected];
    _didSelected(_model,_selBtn.isSelected);
}
/*按钮点击了*/
- (void)selBtnDidpress:(UIButton*)button{
    [button setSelected:!button.isSelected];
    _didSelected(_model,button.isSelected);
}

- (void)setModel:(XQQFriendModel *)model{
    _model = model;
    if ([model.iconImgaeURL isEqualToString:@"1.jpg"]) {
        _iconImageView.image = [UIImage imageNamed:@"1.jpg"];
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImgaeURL] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    }
    _nickNameLabel.text = [model.nickName isEqualToString:@"暂未设置"] ? model.userName : model.nickName;
}
@end
