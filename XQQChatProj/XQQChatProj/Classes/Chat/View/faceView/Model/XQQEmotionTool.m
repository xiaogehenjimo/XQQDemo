//
//  XQQEmotionTool.m
//  XQQChatProj
//
//  Created by xuqinqiang on 2017/5/23.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQEmotionTool.h"
#import "XQQFaceModel.h"

#define HWRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]
@implementation XQQEmotionTool
static NSMutableArray *_recentEmotions;

+ (void)initialize{
    
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:HWRecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

+ (XQQFaceModel *)emotionWithChs:(NSString *)chs{
    
    NSArray *defaults = [self defaultEmotions];
    for (XQQFaceModel *emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    
    NSArray *lxhs = [self lxhEmotions];
    for (XQQFaceModel *emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    NSArray *pandaArr = [self pandaEmotions];
    for (XQQFaceModel *emotion in pandaArr) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    return nil;
}

+ (void)addRecentEmotion:(XQQFaceModel *)emotion{
    
    // 删除重复的表情
    [_recentEmotions removeObject:emotion];
    
    // 将表情放到数组的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 将所有的表情数据写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:HWRecentEmotionsPath];
}

/**
 *  返回装着HWEmotion模型的数组
 */
+ (NSArray *)recentEmotions{
    
    return _recentEmotions;
}

static NSArray *_emojiEmotions, *_defaultEmotions, *_lxhEmotions, *_pandaEmotions;

+ (NSArray *)emojiEmotions{
    
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:nil];
        _emojiEmotions = [XQQFaceModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
}

+ (NSArray *)defaultEmotions{
    
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultInfo" ofType:@"plist"];
        _defaultEmotions = [XQQFaceModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}

+ (NSArray *)lxhEmotions{
    
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lxhInfo" ofType:@"plist"];
        _lxhEmotions = [XQQFaceModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;
}

+ (NSArray *)pandaEmotions{
    if (!_pandaEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emotion3" ofType:@"plist"];
        _lxhEmotions = [XQQFaceModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _pandaEmotions;
}
@end
