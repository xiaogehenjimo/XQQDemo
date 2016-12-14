//
//  XQQVoiceAnimationView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/25.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQVoiceAnimationView.h"
#define viewTag 123456789
@interface XQQVoiceAnimationView ()
/**动画数组*/
@property(nonatomic, strong)  NSMutableArray *  animationArr;
/** imageView */
@property(nonatomic, strong)  UIImageView    *  animationImageView;

@end

@implementation XQQVoiceAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //初始化动画数组
        _animationArr = @[].mutableCopy;
        for (NSInteger i = 1; i < 20; i ++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld",@"VoiceSearchFeedback",i]];
            [_animationArr addObject:image];
        }
        self.animationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:self.animationImageView];
        self.animationImageView.center = self.center;
        self.animationImageView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.f];
        //self.animationImageView.alpha = 0.5;
        self.animationImageView.animationImages = _animationArr;
        self.animationImageView.animationDuration = 1.0f;
        self.animationImageView.animationRepeatCount = 0;
        [self.animationImageView startAnimating];
    }
    return self;
}
/**显示动画的View*/
+(void)showAnimationWithView:(UIView*)view{
    XQQVoiceAnimationView * animationView = [[XQQVoiceAnimationView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    animationView.tag = viewTag;
    [view addSubview:animationView];
}
/**隐藏动画的View*/
+(void)hideAnimationWithView:(UIView*)view{
    for (UIView * sub in view.subviews) {
        if ([sub isKindOfClass:[XQQVoiceAnimationView class]]) {
            [sub removeFromSuperview];
        }
    }
}
@end
