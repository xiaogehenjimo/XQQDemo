//
//  XQQFaceSmallView.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQAllFaceView.h"
@interface XQQFaceSmallView : UIScrollView
/*表情的数组*/
@property(nonatomic, strong)  NSArray  *  faceArr;
/*传递当前页的page 和总数*/
@property (nonatomic, copy)  void(^pageControlBlock)(NSInteger pageCount,NSInteger currentPage);
@end
