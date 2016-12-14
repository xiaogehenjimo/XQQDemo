//
//  XQQFaceBigView.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQQFaceBigView : UIView
/*总页数*/
@property(nonatomic, assign)  NSInteger   pageNum;
/*数组*/
@property(nonatomic, strong)  NSArray  *  faceArr;
/*scrollView*/
@property(nonatomic, strong)  UIScrollView  *  scrollView;
/*传递当前页的page 和总数*/
@property (nonatomic, copy)  void(^pageControlBlock)(NSInteger pageCount,NSInteger currentPage);
@end
