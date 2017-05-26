//
//  XQQEssencePhotoView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQEssencePhotoView.h"

#import "XQQProgrossView.h"

@interface XQQEssencePhotoView ()
/** 图片 */
@property(nonatomic, strong)  UIImageView  *  backImageView;
/** 左上角图片 */
@property(nonatomic, strong)  UIImageView  *  gifImageView;
/** 底部的查看更多按钮 */
@property(nonatomic, strong)  UIButton     *  bottomBtn;

@end

@implementation XQQEssencePhotoView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = XQQBGColor;
        //初始化控件
        self.backImageView = [[UIImageView alloc]init];
        self.backImageView.clipsToBounds = YES;
        self.gifImageView = [[UIImageView alloc]init];
        self.gifImageView.image = [UIImage imageNamed:@"common-gif"];
        self.bottomBtn = [[UIButton alloc]init];
        [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"see-big-picture-background"] forState:UIControlStateNormal];
        [self.bottomBtn setImage:[UIImage imageNamed:@"see-big-picture"] forState:UIControlStateNormal];
        [self.bottomBtn setTitle:@"点击查看大图" forState:UIControlStateNormal];
        [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bottomBtn addTarget:self action:@selector(bottomBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        self.progressView = [[DALabeledCircularProgressView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        [self addSubview:self.backImageView];
        [self addSubview:self.gifImageView];
        [self addSubview:self.bottomBtn];
        [self addSubview:self.progressView];
        self.autoresizingMask = UIViewAutoresizingNone;
        
        self.progressView.roundedCorners = 5;
        self.progressView.progressLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    //给控件frame
    self.backImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.gifImageView.frame = CGRectMake(0, 0, 30, 30);
    self.bottomBtn.frame = CGRectMake(0,frame.size.height - 40, frame.size.width, 40);
    self.progressView.center = self.backImageView.center;
}

- (void)setFrameModel:(XQQEssenceFrameModel *)frameModel{
    _frameModel = frameModel;
    XQQEssenceModel * essenceModel = frameModel.essenceModel;
    //设置图片
    //    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:essenceModel.image0]];
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:essenceModel.image0] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // receivedSize : 已经接收的图片大小
        // expectedSize : 图片的总大小
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        self.progressView.progress = progress;
        self.progressView.hidden = NO;
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    
    
    //    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:essenceModel.image0] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //        CGFloat progress = 1.0 * receivedSize / expectedSize;
    //        self.progressView.progress = progress;
    //        self.progressView.hidden = NO;
    //        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    //    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //
    //    }];
    
    if ([[essenceModel.image0.pathExtension lowercaseString] isEqualToString:@"gif"]) {
        self.gifImageView.hidden = NO;
    }else{
        self.gifImageView.hidden = YES;
    }
    
    if (frameModel.bigPicture) {
        self.backImageView.contentMode = UIViewContentModeTop;
        self.bottomBtn.hidden = NO;
    }else{
        self.backImageView.contentMode = UIViewContentModeScaleToFill;
        self.bottomBtn.hidden = YES;
    }
}


- (void)bottomBtnDidPress:(UIButton*)button{
    _btnDidPress();
}

@end
