//
//  XQQWebViewController.m
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/16.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQWebViewController.h"

@interface XQQWebViewController ()<UIWebViewDelegate>
/*webView*/
@property(nonatomic, strong)  UIWebView  *  webView;



@end

@implementation XQQWebViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, iphoneWidth, iphoneHeight - 64)];
    _webView.delegate = self;
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.detailUrl]];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end
