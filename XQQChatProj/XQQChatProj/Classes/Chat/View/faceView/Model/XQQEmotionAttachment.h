//
//  XQQEmotionAttachment.h
//  XQQChatProj
//
//  Created by xuqinqiang on 2017/5/23.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQQFaceModel.h"

@interface XQQEmotionAttachment : NSTextAttachment
@property (nonatomic, strong) XQQFaceModel *emotion;
@end
