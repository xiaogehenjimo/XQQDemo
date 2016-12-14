//
//  XQQEssenceVoiceView.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQEssenceFrameModel.h"
#import "XQQEssenceModel.h"

typedef void(^voiceImageViewDidPress)();
@interface XQQEssenceVoiceView : UIView
/** 中间的声音按钮 */
@property(nonatomic, strong)  UIImageView  *  voiceImageView;
/** 数据模型 */
@property(nonatomic, strong)  XQQEssenceModel  *  essenceModel;
/** 音频点击 */
@property (nonatomic, copy)  voiceImageViewDidPress  voiceDidPress;

@end
