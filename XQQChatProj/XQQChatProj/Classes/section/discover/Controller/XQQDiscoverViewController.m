//
//  XQQDiscoverViewController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/16.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQDiscoverViewController.h"
#import "XQQScrollMenuView.h"
#import "XQQDiscoverOneController.h"
#import "XQQDiscoverTwoController.h"
#import "XQQDiscoverThreeController.h"
#import "XQQDiscoverFourController.h"
#import "XQQDiscoverFiveController.h"
#import "XQQDiscoverSixController.h"
#import "XQQDiscoverSevenController.h"

@interface XQQDiscoverViewController ()<scrollMenuDelegate,UIScrollViewDelegate>
/**顶部滚动菜单*/
@property(nonatomic, strong)  XQQScrollMenuView *  menuView;
/**本控制器的滚动视图*/
@property(nonatomic, strong)  UIScrollView      *  scrollView;

@end

@implementation XQQDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置UI
    [self setUpTitleView];
}

/**设置titleView*/
- (void)setUpTitleView{
    self.view.backgroundColor = XQQBGColor;
//    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //左边按钮
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" hightImage:@"MainTagSubIconClick" target:self action:@selector(leftItemClicked)];
    //初始滚动菜单
    NSArray * titleArr = @[@"精华",@"图片",@"段子",@"声音",@"视频",@"精华",@"图片"];
    NSArray * controllerNameArr = @[@"XQQDiscoverOneController",@"XQQDiscoverTwoController",@"XQQDiscoverThreeController",@"XQQDiscoverFourController",@"XQQDiscoverFiveController",@"XQQDiscoverSixController",@"XQQDiscoverSevenController"];
    _menuView = [[XQQScrollMenuView alloc]initWithFrame:CGRectMake(0, 64, iphoneWidth, 40)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _menuView.titleArr = titleArr;
    _menuView.scrollDelegate = self;
    [self.view addSubview:_menuView];
    //添加控制器
    NSArray * resultArr = [_menuView addChildrenControllersWithArr:controllerNameArr AndSuperController:self];
    //初始化滚动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_menuView.frame), iphoneWidth, iphoneHeight - 49 - _menuView.frame.size.height - 64)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    //添加子控制器的View到 当前控制器的滚动视图中 初始为0
    [_menuView addSubViewToScrollViewWithIndex:0 superView:_scrollView];
    _scrollView.contentSize = CGSizeMake(resultArr.count * iphoneWidth, _scrollView.frame.size.height);
}
#pragma mark - scrollMenuDelegate

- (void)scrollMenuDidPressBtn:(XQQScrollBtn*)button index:(NSInteger)index{
    //切换当前控制器滚动视图的偏移量
    [_menuView changeScrollViewContentOffsetWithIndex:index scrollView:_scrollView];
    //一个一个添加控制器的View 只有切换到这个页面才添加这个控制器的View
    [_menuView addSubViewToScrollViewWithIndex:index superView:_scrollView];
    //发送通知
    [self postNoticeWithIndex:index];
}

- (void)postNoticeWithIndex:(NSInteger)index{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVC" object:@""];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //计算偏移量
    NSInteger x = scrollView.contentOffset.x / iphoneWidth;
    //一个一个添加控制器的View 只有切换到这个页面才添加这个控制器的View
    [_menuView addSubViewToScrollViewWithIndex:x superView:_scrollView];
    //上方按钮的偏移量
    _menuView.index = x;
    //改变顶部按钮的颜色
    [_menuView changeBtnStatesWithBtnIndex:x];
    
    [self postNoticeWithIndex:x];
}


- (void)leftItemClicked{
//    XQQRecommendViewController * recomendVC = [[XQQRecommendViewController alloc]init];
//    [self.navigationController pushViewController:recomendVC animated:YES];
}
@end
