//
//  XQQDetailLocationController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/29.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQDetailLocationController.h"
#import "XQQPullViewController.h"
#import "XQQRouteViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "XQQBaiduMapTool.h"
@interface XQQDetailLocationController ()<BMKGeoCodeSearchDelegate>
/*查看全景按钮*/
@property(nonatomic, strong)  UIButton  *  lookPullBtn;
/*要传递的经纬度*/
@property(nonatomic, assign)  CLLocationCoordinate2D   sendCoor;
/*点击的大头针*/
@property(nonatomic, strong)  BMKPointAnnotation * touchAnnotation;
/*输入框*/
@property(nonatomic, strong)  UITextField  *  searchTextField;
/*搜索的按钮*/
@property(nonatomic, strong)  UIButton     *  searchBtn;
/*geo搜索*/
@property(nonatomic, strong)  BMKPoiSearch * poiCodesearch;
/*poi搜索存储数组*/
@property(nonatomic, strong)  NSMutableArray *  poiResultArr;
/*搜索的结果*/
@property(nonatomic, strong)  BMKPoiResult   * poiResult;
/*大头针数组*/
@property(nonatomic, strong)  NSMutableArray * annotationArr;
/** 定位 */
@property(nonatomic, strong)  BMKLocationService  *  locationService;
/** 当前的位置 */
@property(nonatomic, assign)  CLLocationCoordinate2D   myCoord;
/** 地理编码 */
@property(nonatomic, strong)  BMKGeoCodeSearch  * searcher;
/** 当前所在的城市 */
@property(nonatomic, strong)  NSString  *  currentCity;

@end


@implementation XQQDetailLocationController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.poiCodesearch.delegate = self;
    self.locationService.delegate = self;
    self.mapView.delegate = self;
     _searcher.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.poiCodesearch.delegate = nil;
    self.locationService.delegate = nil;
    self.mapView.delegate = nil;
     _searcher.delegate = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"位置信息";
    //搜索框
    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.mapView];
    /*大头针*/
    BMKPointAnnotation * myAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D rr;
    rr.latitude = self.locationMessagebody.latitude;
    rr.longitude = self.locationMessagebody.longitude;
    myAnnotation.coordinate = rr;
    _sendCoor = rr;
    myAnnotation.title = self.locationMessagebody.address;
    myAnnotation.subtitle = self.locationMessagebody.address;
    [_mapView addAnnotation:myAnnotation];
    [_mapView setCompassPosition:CGPointMake(180,200)];
    _locationService = [[BMKLocationService alloc]init];
    [_locationService startUserLocationService];
}

- (void)descBtnDidPress{
    XQQRouteViewController * routeVC = [[XQQRouteViewController alloc]init];
    routeVC.myCoord = _myCoord;
    routeVC.endCoord = _sendCoor;
    routeVC.myCity = _currentCity;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择方式" message:@"选择您的交通方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * busAct = [UIAlertAction actionWithTitle:@"公交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        routeVC.routeType =  XQQRouteTypeBus;
        [self.navigationController pushViewController:routeVC animated:YES];
    }];
    UIAlertAction * workAct = [UIAlertAction actionWithTitle:@"步行" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        routeVC.routeType =  XQQRouteTypeWalk;
        [self.navigationController pushViewController:routeVC animated:YES];
    }];
    UIAlertAction * driveAct = [UIAlertAction actionWithTitle:@"驾车" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        routeVC.routeType =  XQQRouteTypeDrive;
        [self.navigationController pushViewController:routeVC animated:YES];
    }];
    [alert addAction:driveAct];
    [alert addAction:workAct];
    [alert addAction:busAct];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    BMKLocationViewDisplayParam * param = [[BMKLocationViewDisplayParam alloc]init];
    param.locationViewImgName = @"icon_center_point";
    [_mapView updateLocationViewWithParam:param];
    if (userLocation.location) {
        _myCoord = userLocation.location.coordinate;
    }
    
    [[XQQBaiduMapTool sharedTool] startReverseGeoCodeSearch:userLocation.location.coordinate complete:^(BMKGeoCodeSearch *searcher, BMKReverseGeoCodeResult *searchResult, BMKSearchErrorCode error) {
        if (error == BMK_SEARCH_NO_ERROR) {
            //在此处理正常结果
            _currentCity = [searchResult.address substringWithRange:NSMakeRange(0, 3)];
        }else {
            NSLog(@"抱歉，未找到结果");
        }
    }];
    [_locationService stopUserLocationService];
}

#pragma mark - BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"大头针点击点击");
    _sendCoor = view.annotation.coordinate;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    [self.searchTextField resignFirstResponder];
    NSLog(@"map view: click blank");
    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    //    if (_touchAnnotation) {
    //        [_mapView removeAnnotation:_touchAnnotation];
    //    }
    //    _touchAnnotation = [[BMKPointAnnotation alloc]init];
    //    _touchAnnotation.coordinate = coordinate;
    //    _touchAnnotation.title = @"点击了这里";
    //    _sendCoor = coordinate;
    //    [_mapView addAnnotation:_touchAnnotation];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self.searchTextField resignFirstResponder];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *constID =@"myAnnotation";
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:constID];
        if (newAnnotationView ==nil) {
            newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:constID];
        }
        //设置该标注点动画显示
        newAnnotationView.animatesDrop = YES;
        newAnnotationView.annotation = annotation;
        //点击显示图详情
        newAnnotationView.canShowCallout =YES;
        //[newAnnotationView setSelected:YES animated:YES];
        newAnnotationView.image = [UIImage imageNamed:@"datouzhen.png"];
        newAnnotationView.frame = CGRectMake(newAnnotationView.frame.origin.x, newAnnotationView.frame.origin.y, 40, 40);
        //定制大头针弹出气泡
        UIView * paopaoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 80)];
        paopaoView.layer.cornerRadius = 14;
        paopaoView.layer.masksToBounds = YES;
        paopaoView.backgroundColor = [UIColor whiteColor];
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, paopaoView.frame.size.width, 40)];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = annotation.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        //titleLabel.backgroundColor = [UIColor redColor];
        [paopaoView addSubview:titleLabel];
        UIButton * descBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), paopaoView.frame.size.width/2, 40)];
        [descBtn setTitle:@"去这里" forState:UIControlStateNormal];
        [descBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [descBtn addTarget:self action:@selector(descBtnDidPress) forControlEvents:UIControlEventTouchUpInside];
        [descBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [paopaoView addSubview:descBtn];
        UIButton * fullViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(descBtn.frame), descBtn.frame.origin.y, paopaoView.frame.size.width/2, 40)];
        [fullViewBtn setTitle:@"查看全景" forState:UIControlStateNormal];
        [fullViewBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [fullViewBtn addTarget:self action:@selector(fullBtnDidPress) forControlEvents:UIControlEventTouchUpInside];
        [fullViewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [paopaoView addSubview:fullViewBtn];
        BMKActionPaopaoView * pp = [[BMKActionPaopaoView alloc]initWithCustomView:paopaoView];
        newAnnotationView.paopaoView = nil;
        newAnnotationView.paopaoView = pp;
        return newAnnotationView;
    }
    return nil;
}


#pragma mark - activity
/*全景*/
- (void)fullBtnDidPress{
    XQQPullViewController * pullVC = [[XQQPullViewController alloc]init];
    pullVC.coord = _sendCoor;
    [self.navigationController pushViewController:pullVC animated:YES];
}

- (void)lookPullBtnDidPress{
    //全景的controller
    
}
/*搜索按钮点击*/
- (void)searchBtnDidPress{
    //拿到输入框的值
    NSString * searchStr = self.searchTextField.text;
    //检索的参数信息类
    BMKNearbySearchOption *baseSearch = [[BMKNearbySearchOption alloc]init];
    baseSearch.keyword = searchStr;
    baseSearch.location = _sendCoor;
    baseSearch.radius = 5000;
    baseSearch.sortType = BMK_POI_SORT_BY_DISTANCE;
    BOOL flag = [_poiCodesearch poiSearchNearBy:baseSearch];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}
#pragma mark - 添加大头针
- (void)AddAnnotationViews{
    
    if (self.annotationArr.count > 0) {
        [_mapView removeAnnotations:self.annotationArr];
        [self.annotationArr removeAllObjects];
    }
    for (BMKPoiInfo * info in self.poiResultArr) {
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = info.pt;
        annotation.title = info.name;
        annotation.subtitle = info.address;
        [self.annotationArr addObject:annotation];
    }
    //    for (NSInteger i = 0; i < self.annotationArr.count; i ++) {
    //        BMKPointAnnotation *  annotation = self.annotationArr[i];
    //
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [_mapView addAnnotation:annotation];
    //        });
    //    }
    [_mapView addAnnotations:self.annotationArr];
}

#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    _poiResult = poiResult;
    [self.poiResultArr setArray:poiResult.poiInfoList];
    //添加大头针
    [self AddAnnotationViews];
}
/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
}



#pragma mark - setter&getter

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchTextField.frame)+5, iphoneWidth, iphoneHeight - 64 - 5 - self.searchTextField.frame.size.height)];
        _mapView.showsUserLocation = NO;
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.showMapScaleBar = YES;
        _mapView.showsUserLocation = YES;
        _mapView.buildingsEnabled = YES;
        _mapView.delegate = self;
        CLLocationCoordinate2D rr;
        rr.latitude = self.locationMessagebody.latitude;
        rr.longitude = self.locationMessagebody.longitude;
        BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance(rr, 500, 500);
        [_mapView setRegion:region animated:YES];
    }
    return _mapView;
}
- (BMKPoiSearch *)poiCodesearch{
    if (!_poiCodesearch) {
        _poiCodesearch = [[BMKPoiSearch alloc]init];
    }
    return _poiCodesearch;
}
- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 64, iphoneWidth - 10 - 10 - 60 - 10, 44)];
        _searchTextField.delegate = self;
        _searchTextField.backgroundColor = [UIColor lightGrayColor];
        _searchTextField.placeholder = @"输入地点搜索一下";
        _searchTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _searchTextField;
}
- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.searchTextField.frame)+10, self.searchTextField.frame.origin.y, 60, 44)];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_searchBtn addTarget:self action:@selector(searchBtnDidPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
- (UIButton *)lookPullBtn{
    if (!_lookPullBtn) {
        _lookPullBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        [_lookPullBtn setTitle:@"查看全景" forState:UIControlStateNormal];
        [_lookPullBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_lookPullBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_lookPullBtn addTarget:self action:@selector(lookPullBtnDidPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookPullBtn;
}
- (NSMutableArray *)poiResultArr{
    if (!_poiResultArr) {
        _poiResultArr = [[NSMutableArray alloc]init];
    }
    return _poiResultArr;
}
- (NSMutableArray *)annotationArr{
    if (!_annotationArr) {
        _annotationArr = @[].mutableCopy;
    }
    return _annotationArr;
}
- (void)dealloc
{
    _mapView.delegate = nil;
}

@end
