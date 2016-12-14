//
//  XQQLookGroupCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/6.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQLookGroupCell.h"

#define boardWidth 10
@interface XQQLookGroupCell ()
/*头像*/
@property(nonatomic, strong) UIImageView * iconImageView;
/** 名字 */
@property(nonatomic, strong)  UILabel  *  nameLabel;


@end

@implementation XQQLookGroupCell

+ (instancetype)cellForTableView:(UITableView *)tableView
                       indexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"lookGroupCell";
    XQQLookGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XQQLookGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(boardWidth, boardWidth, 40, 40)];
        _iconImageView.layer.cornerRadius = 3.0;
        _iconImageView.layer.masksToBounds = YES;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.xqq_right, boardWidth, iphoneWidth - 40 - 30, 30)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)setGroup:(EMGroup *)group{
    _group = group;
    _iconImageView.image = [UIImage imageNamed:@"ff_IconGroup"];
    _nameLabel.text = [NSString stringWithFormat:@"%@(%ld)",group.groupSubject,group.groupOccupantsCount];
}

@end
