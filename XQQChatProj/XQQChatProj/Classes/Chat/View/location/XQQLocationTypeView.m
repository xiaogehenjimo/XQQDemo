//
//  XQQLocationTypeView.m
//  XQQChatProj
//
//  Created by XQQ on 2017/1/6.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQLocationTypeView.h"

#define boardWidth 10

@interface XQQLocationTypeView ()

/*线*/
@property(nonatomic, strong)  UIView * lineView;
/** 存储按钮的数组 */
@property(nonatomic, strong)  NSMutableArray  *  buttonArr;

@end

@implementation XQQLocationTypeView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XQQGrayColor(251);
        self.layer.borderWidth = .2f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        UIButton * firstBtn = nil;
        for (NSInteger i = 0; i < 4; i ++) {
            CGFloat width = (frame.size.width - 5 * boardWidth)/4.0;
            CGFloat height = frame.size.height - 2 * boardWidth;
            
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i * (width + boardWidth) + boardWidth, boardWidth, width, height)];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            
            [button setTitleColor:i == 0 ? XQQColor(61, 170, 249):[UIColor blackColor] forState:UIControlStateNormal];
            button.tag = 12345678 + i;
            [button addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                firstBtn = button;
            }
            [self addSubview:button];
            [self.buttonArr addObject:button];
        }
        //添加下面的线
        CGFloat lineWidth = firstBtn.xqq_width * 0.8;
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,firstBtn.xqq_bottom + 4, lineWidth, 2)];
        lineView.xqq_centerX = firstBtn.xqq_centerX;
        lineView.backgroundColor = XQQColor(61, 170, 249);
        [self addSubview:lineView];
        self.lineView = lineView;
    }
    return self;
}


- (void)buttonDidPress:(UIButton*)button{
    for (UIButton * button in self.buttonArr) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:XQQColor(61, 170, 249) forState:UIControlStateNormal];
    //改变线的位置
    [UIView animateWithDuration:.2f animations:^{
        self.lineView.xqq_centerX = button.xqq_centerX;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(typeDidPress:type:)]) {
        [self.delegate typeDidPress:button type:button.tag - 12345678];
    }
}


- (NSMutableArray *)buttonArr{
    if (!_buttonArr) {
        _buttonArr = @[].mutableCopy;
    }
    return _buttonArr;
}

@end
