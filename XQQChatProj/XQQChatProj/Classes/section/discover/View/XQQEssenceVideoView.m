//
//  XQQEssenceVideoView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQEssenceVideoView.h"

@interface XQQEssenceVideoView ()
/** 图片 */
@property(nonatomic, strong)  UIImageView  *  backImageView;


@end


@implementation XQQEssenceVideoView

- (instancetype)init{
    if (self = [super init]) {
        self.backImageView = [[UIImageView alloc]init];
        self.videoImageView = [[UIImageView alloc]init];
        self.videoImageView.userInteractionEnabled = YES;
        self.videoImageView.image = [UIImage imageNamed:@"video-play"];
        UITapGestureRecognizer * sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoImageViewDidPress)];
        [self.videoImageView addGestureRecognizer:sigleTap];
        [self addSubview:self.backImageView];
        [self addSubview:self.videoImageView];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.backImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.videoImageView.frame = CGRectMake(0, 0, 70, 70);
    self.videoImageView.center = self.backImageView.center;
}

- (void)setEssenceModel:(XQQEssenceModel *)essenceModel{
    _essenceModel = essenceModel;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:essenceModel.image0]];
}

- (void)videoImageViewDidPress{
    _videoDidPress(self);
}

@end
