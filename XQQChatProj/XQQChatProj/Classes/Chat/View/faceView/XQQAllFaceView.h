//
//  XQQAllFaceView.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQFaceModel.h"
@interface XQQAllFaceView : UIView
/*点击的block*/
@property (nonatomic, copy)  void(^faceBtnDidSel)(XQQFaceModel * model);
/*表情数组*/
@property(nonatomic, strong)  NSArray  *  detailFaceArr;
@end
