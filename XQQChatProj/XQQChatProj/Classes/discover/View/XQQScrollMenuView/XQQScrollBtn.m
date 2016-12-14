//
//  XQQScrollBtn.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQScrollBtn.h"
#define backGroundColor     [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.f]
#define defaultLabelColor   [UIColor blackColor]
#define defaultBottomColor  [UIColor clearColor]
#define selectedColor       [UIColor redColor]

@interface XQQScrollBtn ()
/**上方的label*/
@property(nonatomic, strong)  UILabel * topLabel;
/**下方的标记View*/
@property(nonatomic, strong)  UIView  *  bottomView;
@end

@implementation XQQScrollBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //创建View
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, .9*frame.size.height)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.textColor = defaultLabelColor;//默认颜色
        _topLabel.font = [UIFont systemFontOfSize:15];
        _topLabel.backgroundColor = backGroundColor;
        [self addSubview:_topLabel];
        //创建底部的View
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topLabel.frame), frame.size.width, frame.size.height - _topLabel.frame.size.height)];
        _bottomView.backgroundColor = backGroundColor;
        [self addSubview:_bottomView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnDidPress:)];
        [self addGestureRecognizer:tap];
        self.layer.borderWidth = 0.2;
        self.layer.borderColor = XQQColorAlpa(233, 233, 233, 255).CGColor;
    }
    return self;
}

//点击事件
- (void)btnDidPress:(UITapGestureRecognizer*)tap{
    XQQScrollBtn * button = (XQQScrollBtn*)tap.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollBtnDidPress:)]) {
        [self.delegate scrollBtnDidPress:button];
    }
}
- (void)setTitle:(NSString*)title{
    _topLabel.text = title;
}
- (void)setTitleColor:(UIColor*)color{
    _topLabel.textColor = color;
}
- (void)setBottomColor:(UIColor*)color{
    _bottomView.backgroundColor = color;
}

@end
