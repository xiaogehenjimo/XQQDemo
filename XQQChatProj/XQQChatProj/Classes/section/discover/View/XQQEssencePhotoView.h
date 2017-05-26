//
//  XQQEssencePhotoView.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQEssenceFrameModel.h"
#import "XQQEssenceModel.h"
#import "XQQProgrossView.h"
#import <DALabeledCircularProgressView.h>
typedef void(^bottomBtnDidPress)();

@interface XQQEssencePhotoView : UIView
/** 数据模型 */
@property(nonatomic, strong)  XQQEssenceFrameModel  *  frameModel;
/** 底部按钮点击的block */
@property (nonatomic, copy)  bottomBtnDidPress  btnDidPress;
/** 进度条 */
@property(nonatomic, strong)  DALabeledCircularProgressView  *  progressView;
@end
