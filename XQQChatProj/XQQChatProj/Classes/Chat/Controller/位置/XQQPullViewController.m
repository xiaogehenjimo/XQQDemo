//
//  XQQPullViewController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/29.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQPullViewController.h"
#import <BaiduPanoSDK/BaiduPanoramaView.h>
@interface XQQPullViewController ()<BaiduPanoramaViewDelegate>
/*BaiduPanoramaView*/
@property (nonatomic, strong) BaiduPanoramaView * panoramaView;
@end

@implementation XQQPullViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"全景信息";
    [self customPanoView];
}
- (void)customPanoView{
    self.panoramaView = [[BaiduPanoramaView alloc]initWithFrame:CGRectMake(0, 64, iphoneWidth, iphoneHeight - 64) key:@"1yCPGCgKuUHyvyqET5DfUYbxl7bIG6sU"];
    self.panoramaView.delegate = self;
    [self.view addSubview:self.panoramaView];
    [self.panoramaView setPanoramaImageLevel:ImageDefinitionMiddle];
    //指定经纬度
    CLLocationCoordinate2D coord = _coord;
    [self.panoramaView setPanoramaWithLon:coord.longitude lat:coord.latitude];
}
#pragma mark - panorama view delegate

- (void)panoramaWillLoad:(BaiduPanoramaView *)panoramaView {
    
}

- (void)panoramaDidLoad:(BaiduPanoramaView *)panoramaView descreption:(NSString *)jsonStr {
    
}


- (void)panoramaLoadFailed:(BaiduPanoramaView *)panoramaView error:(NSError *)error {
    
}

- (void)panoramaView:(BaiduPanoramaView *)panoramaView overlayClicked:(NSString *)overlayId {
    
}

@end
