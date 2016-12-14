//
//  XQQEssenceVoiceView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQEssenceVoiceView.h"

@interface XQQEssenceVoiceView ()
/** 大图 */
@property(nonatomic, strong)  UIImageView  *  backImageView;

@end

@implementation XQQEssenceVoiceView

- (instancetype)init{
    if (self = [super init]) {
        self.backImageView = [[UIImageView alloc]init];
        self.voiceImageView = [[UIImageView alloc]init];
        self.voiceImageView.image = [UIImage imageNamed:@"playButtonPlay"];
        UITapGestureRecognizer * sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceImageViewDidPress)];
        [self.voiceImageView addGestureRecognizer:sigleTap];
        [self addSubview:self.backImageView];
        [self addSubview:self.voiceImageView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.backImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.voiceImageView.frame = CGRectMake(0, 0, 70, 70);
    self.voiceImageView.center = self.backImageView.center;
}

- (void)setEssenceModel:(XQQEssenceModel *)essenceModel{
    _essenceModel = essenceModel;
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:essenceModel.image0]];
    
    
}

- (void)voiceImageViewDidPress{
    _voiceDidPress();
}

@end
