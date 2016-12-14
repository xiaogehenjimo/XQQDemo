//
//  XQQPersionCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/18.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQPersionCell.h"

@interface XQQPersionCell ()


@end

@implementation XQQPersionCell

+ (instancetype)cellForTableView:(UITableView*)tableView
                  rowAtIndexPath:(NSIndexPath*)inidexPath{
    static NSString * cellID = @"persionCell";
    XQQPersionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XQQPersionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 30)];
       // _leftLabel.backgroundColor = [UIColor redColor];
        
        _centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLabel.frame)+5 , 5, iphoneWidth - 10 - _leftLabel.frame.size.width -5-10-30, 30)];
        //_centerLabel.backgroundColor = [UIColor redColor];
        _centerLabel.textAlignment = NSTextAlignmentRight;
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iphoneWidth - 10 - 80, 5, 50, 50)];
        _iconImageView.backgroundColor = [UIColor redColor];
        _iconImageView.layer.cornerRadius = 25;
        _iconImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_leftLabel];
        [self.contentView addSubview:_centerLabel];
        [self.contentView addSubview:_iconImageView];
        
        
    }
    return self;
}


@end
