//
//  XQQFaceView.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQQFaceView : UIView
/*底部的scrollView*/
@property (nonatomic, strong)  UIScrollView  *  bottomScrollView;
/*上面的大scrollView*/
@property (nonatomic, strong)  UIScrollView  *  topBigScrollView;
/*下方选择按钮点击的block*/
@property (nonatomic, copy)    void(^bottomFaceTypeBtnPress)(NSInteger btnIndex);
/** 发送表情按钮点击的block */
@property (nonatomic, copy)    void(^sendFaceBtnPressBlock)();

@end
