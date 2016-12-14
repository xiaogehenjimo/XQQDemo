//
//  XQQCommentView.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XQQCommentModel.h"
@interface XQQCommentView : UIView
/** 评论数组 */
@property(nonatomic, strong)  NSArray <XQQCommentModel*> *  commentArr;
/** 评论View的高度 */
@property(nonatomic, assign)  CGFloat   commentHeight;

@end
