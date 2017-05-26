//
//  XQQScrollMenuView.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQQScrollBtn.h"
@protocol scrollMenuDelegate <NSObject>
/**点击了顶部的某个按钮*/
- (void)scrollMenuDidPressBtn:(XQQScrollBtn*)button index:(NSInteger)index;
@end

@interface XQQScrollMenuView : UIScrollView
/**滚动视图显示的标题数组*/
@property(nonatomic, strong)  NSArray  *  titleArr;
/**滚动视图的按钮数组*/
@property(nonatomic, strong)  NSMutableArray  *  btnArr;
/**下方传递的滚动的偏移量*/
@property(nonatomic, assign)  NSInteger   index;
/**子视图控制器数组 !必须添加完控制器才能获取到*/
@property(nonatomic, strong)  NSArray  *  controllers;
/**代理*/
@property(nonatomic, weak)  id<scrollMenuDelegate> scrollDelegate;
/**初始化方法*/
+ (instancetype)createTopScrollViewWithFrame:(CGRect)frame;
/**添加控制器*/
- (NSArray*)addChildrenControllersWithArr:(NSArray*)controllers AndSuperController:(id)superController;
/**添加子视图*/
- (void)addSubViewToScrollView:(UIScrollView*)scrollView
                 controllerArr:(NSArray*)controllersArr;
/**设置按钮是否为选中状态*/
- (void)changeBtnStatesWithBtnIndex:(NSInteger)index;
/**返回子视图控制器 !必须添加完控制器才能获取到*/
- (NSArray*)GetchildrenControllers;
/**根据下标添加控制器的View*/
- (void)addSubViewToScrollViewWithIndex:(NSInteger)index superView:(UIScrollView*)superView;
/**改变控制器中滚动视图的偏移量*/
- (void)changeScrollViewContentOffsetWithIndex:(NSInteger)index scrollView:(UIScrollView*)scrollView;

@end
