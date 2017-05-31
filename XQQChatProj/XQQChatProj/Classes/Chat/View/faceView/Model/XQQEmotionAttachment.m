//
//  XQQEmotionAttachment.m
//  XQQChatProj
//
//  Created by xuqinqiang on 2017/5/23.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQEmotionAttachment.h"

@implementation XQQEmotionAttachment
- (void)setEmotion:(XQQFaceModel *)emotion{
    
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}
@end
