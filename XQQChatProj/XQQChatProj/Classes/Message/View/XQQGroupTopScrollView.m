//
//  XQQGroupTopScrollView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/2.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQGroupTopScrollView.h"

#define boardWidth 10
#define subViewWidth 40

@implementation XQQGroupTopScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XQQColor(241, 241, 241);
//        self.showsVerticalScrollIndicator = NO;
//        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)setSelFriendArr:(NSArray *)selFriendArr{
    _selFriendArr = selFriendArr;
    //添加头像  40x40
    if (self.subviews.count > 0) {
        //先移除所有子视图
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (NSInteger i = 0; i < selFriendArr.count; i ++) {
       XQQFriendModel * friendModel = selFriendArr[i];
        CGFloat x = i * (subViewWidth + boardWidth) + boardWidth;
        UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, boardWidth, subViewWidth, subViewWidth)];
        iconImageView.alpha = 1;
        iconImageView.opaque = YES;
        iconImageView.hidden = NO;
        iconImageView.backgroundColor = [UIColor redColor];
        NSString * iconURL = friendModel.iconImgaeURL;
        if ([iconURL isEqualToString:@"1.jpg"]) {
            iconImageView.image = [UIImage imageNamed:@"1.jpg"];
        }else{
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        }
        [self addSubview:iconImageView];
    }
    UIImageView * lastImageView = self.subviews.lastObject;
    self.contentSize = CGSizeMake(CGRectGetMaxX(lastImageView.frame) + boardWidth, 60);
//    NSLog(@"子视图个数:%ld- 最后一个视图的frame:%@ - 包含的大小:%@",self.subviews.count,NSStringFromCGRect(lastImageView.frame),NSStringFromCGSize(self.contentSize));
}
@end
