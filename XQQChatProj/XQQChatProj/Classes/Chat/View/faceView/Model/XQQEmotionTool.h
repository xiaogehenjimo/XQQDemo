//
//  XQQEmotionTool.h
//  XQQChatProj
//
//  Created by xuqinqiang on 2017/5/23.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XQQFaceModel;

@interface XQQEmotionTool : NSObject
+ (void)addRecentEmotion:(XQQFaceModel *)emotion;
+ (NSArray *)recentEmotions;
+ (NSArray *)defaultEmotions;
+ (NSArray *)lxhEmotions;
+ (NSArray *)emojiEmotions;

/**
 *  通过表情描述找到对应的表情
 *
 *  @param chs 表情描述
 */
+ (XQQFaceModel *)emotionWithChs:(NSString *)chs;
@end
