//
//  XQQPopView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQPopView.h"

@interface XQQPopView()
@property (strong, nonatomic) UIButton *emotionButton;
@property(nonatomic, strong)  UIImageView  *  backImageView;
@end

@implementation XQQPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _backImageView = [[UIImageView alloc]initWithFrame:frame];
        _backImageView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];//64 91   64 64
        _emotionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height *2/3)];
        //_emotionButton.backgroundColor = [UIColor redColor];
        [_backImageView addSubview:_emotionButton];
        [self addSubview:_backImageView];
    }
    return self;
}

- (void)showFrom:(UIButton *)button{
    
    if (button == nil) return;
    // 给popView传递数据
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    // 计算出被点击的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:window];
    self.xqq_y = CGRectGetMidY(btnFrame) - self.xqq_height; // 100
    self.xqq_centerX = CGRectGetMidX(btnFrame);
    UIImage * image = button.imageView.image;
    NSString * btnTitle = button.titleLabel.text;
    if ( image == nil) {
        CGRect buttonFrame = _emotionButton.frame;
        _emotionButton.frame = CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y - .5, buttonFrame.size.width, buttonFrame.size.height);
        [UIView animateWithDuration:.5f delay:.1 usingSpringWithDamping:.9 initialSpringVelocity:.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _emotionButton.frame = buttonFrame;
            _emotionButton.titleLabel.font = [UIFont boldSystemFontOfSize:40];
            [_emotionButton setTitle:btnTitle forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            
        }];
    }else{
        CGRect buttonFrame = _emotionButton.frame;
        _emotionButton.frame = CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y - .5, buttonFrame.size.width, buttonFrame.size.height);
        [UIView animateWithDuration:.5f delay:.1 usingSpringWithDamping:.9 initialSpringVelocity:.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _emotionButton.frame = buttonFrame;
            [_emotionButton setImage:image forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
