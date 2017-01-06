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
    //最多8个
    CGFloat itemWidth = (iphoneWidth - 90) /8.0;
    
    for (NSInteger i = 0; i < selFriendArr.count; i ++) {
       XQQFriendModel * friendModel = selFriendArr[i];
        CGFloat x = i * (itemWidth + boardWidth) + boardWidth;
        UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, boardWidth, itemWidth, itemWidth)];
        iconImageView.alpha = 1;
        iconImageView.opaque = YES;
        iconImageView.hidden = NO;
        iconImageView.backgroundColor = [UIColor redColor];
        NSString * iconURL = friendModel.iconImgaeURL;
        UIImage * placeImage = XQQImageName(@"1.jpg");
        if ([iconURL isEqualToString:@"1.jpg"]) {
            iconImageView.image = placeImage;
        }else{
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:placeImage];
        }
        [self addSubview:iconImageView];
    }
    UIImageView * lastImageView = self.subviews.lastObject;
    
    self.contentSize = CGSizeMake(CGRectGetMaxX(lastImageView.frame) + boardWidth, 0);
    
    CGFloat contentX = selFriendArr.count > 8 ? (selFriendArr.count - 8) * (itemWidth + 10) : 0;
    
    [self setContentOffset:CGPointMake(contentX, lastImageView.xqq_y - 10) animated:YES];
    
    self.xqq_height = itemWidth + 20;
}
@end
