//
//  XQQNavigationController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQNavigationController.h"

@interface XQQNavigationController ()

@end

@implementation XQQNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航条
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NUG_background"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationBar.shadowImage = [[UIImage alloc]init];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
