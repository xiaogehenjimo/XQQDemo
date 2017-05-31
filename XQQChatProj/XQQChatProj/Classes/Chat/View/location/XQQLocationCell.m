//
//  XQQLocationCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/28.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQLocationCell.h"

@implementation XQQLocationCell

+ (instancetype)cellForTableView:(UITableView*)tableView
                       indexPath:(NSIndexPath*)indexPath{
    static NSString * idenStr = @"str";
    XQQLocationCell * cell = [tableView dequeueReusableCellWithIdentifier:idenStr];
    if (!cell) {
        cell = [[XQQLocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenStr];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _addressNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, iphoneWidth - 20, 20)];
        _addressNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_addressNameLabel.frame) + 3, _addressNameLabel.frame.size.width, 20)];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_addressNameLabel];
        [self addSubview:_addressLabel];
    }
    return self;
}

@end
