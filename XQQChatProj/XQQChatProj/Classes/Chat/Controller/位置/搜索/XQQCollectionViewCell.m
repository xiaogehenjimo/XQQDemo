//
//  XQQCollectionViewCell.m
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/12.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQCollectionViewCell.h"

@interface XQQCollectionViewCell ()
/** 头像 */
@property(nonatomic, strong)  UIImageView  *  iconImageView;
/** 标题label */
@property(nonatomic, strong)  UILabel  *  titleLabel;
@end

@implementation XQQCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.xqq_width, self.contentView.xqq_width)];
        //imageView.backgroundColor = [UIColor redColor];
        imageView.layer.cornerRadius = 13.f;
        imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:imageView];
        imageView.image = XQQImageName(@"2.jpg");
        self.iconImageView = imageView;
        UILabel * titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.xqq_bottom + 10, imageView.xqq_width, self.contentView.xqq_height - 10 - imageView.xqq_height)];
        //titleL.backgroundColor = [UIColor purpleColor];
        titleL.textColor = [UIColor blackColor];
        titleL.text = @"微信";
        titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleL];
        self.titleLabel = titleL;
        
        UITapGestureRecognizer * sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionItemDidPress:)];
        [self addGestureRecognizer:sigleTap];
        
    }
    return self;
}

- (void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    
    
    self.iconImageView.image = XQQImageName(dataDict[@"icon"]);
    self.titleLabel.text = dataDict[@"title"];

}

- (void)collectionItemDidPress:(UITapGestureRecognizer*)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionItemDidPress:dataDict:item:)]) {
        [self.delegate collectionItemDidPress:self.index dataDict:self.dataDict item:self];
    }
}



@end
