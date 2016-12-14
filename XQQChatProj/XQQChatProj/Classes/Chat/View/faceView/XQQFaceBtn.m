//
//  XQQFaceBtn.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQFaceBtn.h"

@implementation XQQFaceBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setModel:(XQQFaceModel *)model{
    _model = model;
    self.adjustsImageWhenHighlighted = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    if ([model.png isEqualToString:@""]||model.png == nil) {
        [self setTitle:model.code.emoji forState:UIControlStateNormal];
        
    }else{
        [self setImage:[UIImage imageNamed:model.png] forState:UIControlStateNormal];
    }
}

@end
