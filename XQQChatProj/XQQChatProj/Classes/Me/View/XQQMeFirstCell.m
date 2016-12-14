//
//  XQQMeFirstCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQMeFirstCell.h"
#define boardWidth 5
@interface XQQMeFirstCell ()
/**头像*/
@property(nonatomic, strong)  UIImageView * iconImageView;
/** 昵称 */
@property(nonatomic, strong)  UILabel     *  nickNameLabel;
/** ID */
@property(nonatomic, strong)  UILabel     *  chatIDLabel;
/** 二维码 */
@property(nonatomic, strong)  UIImageView  *  QRCodeImageView;
/** 右侧按钮 */
@property(nonatomic, strong)  UIButton    *  rightBtn;
@end

@implementation XQQMeFirstCell
//90
+ (instancetype)cellForTableView:(UITableView*)tableView
                  rowAtIndexPath:(NSIndexPath*)inidexPath{
    static NSString * firstCellID = @"firstCellID";
    XQQMeFirstCell * firstCell = [tableView dequeueReusableCellWithIdentifier:firstCellID];
    if (!firstCell) {
        firstCell = [[XQQMeFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCellID];
        firstCell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return firstCell;
}

- (void)setPersionInfo:(XQQMeModel *)persionInfo{
    _persionInfo = persionInfo;
    if ([persionInfo.image isEqualToString:@"1.jpg"]) {//默认头像
        _iconImageView.image = [UIImage imageNamed:persionInfo.image];
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:persionInfo.image]];
    }
    if (persionInfo.name == nil || [persionInfo.name isEqualToString:@""]) {
        _nickNameLabel.text = @"还没有昵称";
    }else{
        _nickNameLabel.text = persionInfo.name;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //self.contentView.backgroundColor = XQQColor(250, 250, 250);
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3*boardWidth, 2 * boardWidth, 80, 80)];
        
        _iconImageView.image = [UIImage imageNamed:@"icon3.jpg"];
        _iconImageView.layer.cornerRadius = 8.0;
        _iconImageView.layer.masksToBounds = YES;
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 3 * boardWidth, 6*boardWidth, iphoneWidth - 13 *boardWidth - _iconImageView.frame.size.width - 60, (100 - 12 * boardWidth)/2)];
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:18];
        
        _nickNameLabel.text = @"还没有昵称";
        
        _QRCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iphoneWidth- 2*boardWidth-30-30-boardWidth,35, 30, 30)];
        
        _QRCodeImageView.image = [UIImage imageNamed:@"MyQRCodeAction"];
        
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(iphoneWidth- 2*boardWidth-30, 35, 30, 30)];
        [_rightBtn setImage:[[UIImage imageNamed:@"Mode_listarrow"]imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"Mode_listarrowHL"] forState:UIControlStateHighlighted];
        _rightBtn.backgroundColor = XQQColor(250, 250, 250);
        _chatIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nickNameLabel.frame.origin.x, CGRectGetMaxY(_nickNameLabel.frame) + 3 * boardWidth, iphoneWidth - 10 * boardWidth - _iconImageView.frame.size.width - _rightBtn.frame.size.width - _QRCodeImageView.frame.size.width, _nickNameLabel.frame.size.height)];
        
        _chatIDLabel.text = [NSString stringWithFormat:@"聊天账号: %@",[XQQManager sharedManager].userName];
        //self.accessoryView = _rightBtn;
        [self.contentView addSubview:_QRCodeImageView];
        //[self.contentView addSubview:_rightBtn];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_nickNameLabel];
        [self.contentView addSubview:_chatIDLabel];
    }
    return self;
}

@end
