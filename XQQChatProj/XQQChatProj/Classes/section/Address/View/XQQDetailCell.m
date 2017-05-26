//
//  XQQDetailCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/18.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQDetailCell.h"

#define boardWidth 10
@interface XQQDetailCell ()
/*头像*/
@property(nonatomic, strong)  UIImageView * iconImageView;
/** 名字 */
@property(nonatomic, strong)  UILabel  *  nameLabel;
/** 账号 */
@property(nonatomic, strong)  UILabel  *  accountLabel;
/** 昵称 */
@property(nonatomic, strong)  UILabel  *  nickNameLabel;

@end

@implementation XQQDetailCell

+ (instancetype)cellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    static NSString* detailCellID  = @"detailCell";
    XQQDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    if (!cell) {
        cell = [[XQQDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCellID];
    }
    return cell;
}
//100
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(boardWidth, boardWidth, 80, 80)];
        _iconImageView.image = [UIImage imageNamed:@"5.jpg"];
        _iconImageView.layer.cornerRadius = 7.0;
        _iconImageView.layer.masksToBounds = YES;
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_iconImageView.frame) + boardWidth, boardWidth, iphoneWidth - 3 * boardWidth - 80, 30)];
        //_nameLabel.backgroundColor = [UIColor redColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:19];
        _nameLabel.text = @"暂未设置";
        _nameLabel.textColor = [UIColor blackColor];
        
        _accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame) + 5, _nameLabel.frame.size.width, 20)];
        
        //_accountLabel.backgroundColor = [UIColor redColor];
        _accountLabel.text = [NSString stringWithFormat:@"聊天账号: 12333"];
        
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_accountLabel.frame.origin.x, CGRectGetMaxY(_accountLabel.frame) + 5, _accountLabel.frame.size.width, 20)];
        //_nickNameLabel.backgroundColor = [UIColor redColor];
        _nickNameLabel.text = @"昵称: 他还未设置";
        
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_accountLabel];
        [self.contentView addSubview:_nickNameLabel];
    }
    return self;
}

- (void)setInfoDict:(NSDictionary *)infoDict{
    _infoDict = infoDict;
    NSString * iconURL = infoDict[@"iconURL"];
    if ([iconURL isEqualToString:@"1.jpg"]) {
        _iconImageView.image = [UIImage imageNamed:@"1.jpg"];
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    }
    _accountLabel.text = [NSString stringWithFormat:@"聊天账号: %@",infoDict[@"name"]];
    NSString * nickName = infoDict[@"nickName"];
     _nickNameLabel.text = [NSString stringWithFormat:@"昵称: %@",nickName];
    
}
@end
