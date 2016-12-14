//
//  MainViewController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "MainViewController.h"
#import "XQQMessageViewController.h"
#import "XQQAddressViewController.h"
#import "XQQDiscoverViewController.h"
#import "XQQNavigationController.h"
#import "XQQMeViewController.h"
@interface MainViewController ()

@property(nonatomic,strong) XQQNavigationController * messageVC;

@end

@implementation MainViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = XQQColor(31, 185, 34);
    // [self setUpTabBarItems];
    [self addViewControllers];
}

/**设置子控制器*/
- (void)addViewControllers{
    NSArray * controllersName = @[@"XQQMessageViewController",@"XQQAddressViewController",@"XQQDiscoverViewController",@"XQQMeViewController"];
    NSArray * normalImageArr = @[@"tabbar_mainframe",@"tabbar_contacts",@"tabbar_discover",@"tabbar_me"];
    NSArray * seletedImageArr = @[@"tabbar_mainframeHL",@"tabbar_contactsHL",@"tabbar_discoverHL",@"tabbar_meHL"];
    NSArray * titleArr = @[@"消息",@"通讯录",@"发现",@"我"];
    for (NSInteger i = 0; i < controllersName.count; i ++) {
        Class class = NSClassFromString(controllersName[i]);
        UIViewController * vc = [[class alloc]init];
        vc.title = titleArr[i];
        vc.tabBarItem.title = titleArr[i];
        vc.tabBarItem.image = [[UIImage imageNamed:normalImageArr[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:seletedImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        XQQNavigationController * nav = [[XQQNavigationController alloc]initWithRootViewController:vc];
        if (i == 0) {
            self.messageVC = nav;
        }
        [self addChildViewController:nav];
    }
}

- (void)setUpTabBarItems{
    UITabBarItem * item = [UITabBarItem appearance];
    //普通状态下的文字属性
    NSMutableDictionary * normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    //选中状态下的
    NSMutableDictionary * seletedAttrs = [NSMutableDictionary dictionary];
    seletedAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:seletedAttrs forState:UIControlStateSelected];
}

@end
