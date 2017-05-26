//
//  XQQEssenceToobar.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQEssenceModel.h"
@interface XQQEssenceToobar : UIToolbar
/** 数据模型 */
@property(nonatomic, strong)  XQQEssenceModel  *  essenceModel;
/** 点击的block */
@property (nonatomic, copy)  void(^bottomButtonDidPress)(NSInteger index);
+ (instancetype)toolbar;
@end
