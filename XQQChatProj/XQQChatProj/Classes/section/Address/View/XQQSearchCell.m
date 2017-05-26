//
//  XQQSearchCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/27.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQSearchCell.h"
#define boardWidth 5
@interface XQQSearchCell ()
/*头像*/
@property(nonatomic, strong)  UIImageView * iconImageView;
/** 名字 */
@property(nonatomic, strong)  UILabel     *  nameLabel;
/** 右侧状态信息 */
@property(nonatomic, strong)  UIView      *  statusView;

@end

@implementation XQQSearchCell

+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexPath{
    static NSString * cellID = @"addressCell";
    XQQSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XQQSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.backgroundColor = XQQColor(242, 242, 242);
    cell.contentView.layer.cornerRadius = 10.0;
    cell.contentView.layer.masksToBounds = YES;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 6;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.image = [UIImage imageNamed:@"1.jpg"];
        
         _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _statusView = [[UIView alloc]init];
        _statusView.layer.cornerRadius = 15;
        _statusView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_statusView];
        
    }
    return self;
}

//50
- (void)setCellWidth:(CGFloat)cellWidth{
    _cellWidth = cellWidth;
   
    _iconImageView.frame = CGRectMake(boardWidth, boardWidth, 40, 40);
    
   
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 2 * boardWidth, boardWidth + 5, cellWidth - 3 * boardWidth - 5 - _iconImageView.frame.size.width - 30, 20);
    _statusView.frame = CGRectMake(cellWidth - boardWidth - 30, boardWidth + 5, 30, 30);
    
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
