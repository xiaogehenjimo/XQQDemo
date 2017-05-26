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
#import "XQQSearchTopVIew.h"
#import "XQQSearchBottomTableView.h"
#import "XQQBaiduTool.h"

@interface XQQDetailLocationController ()<BMKGeoCodeSearchDelegate,xqq_searchTopViewDelegate,UISearchBarDelegate,historyCellDidPressDelegate>
/*查看全景按钮*/
@property(nonatomic, strong)  UIButton  *  lookPullBtn;
/*要传递的经纬度*/
@property(nonatomic, assign)  CLLocationCoordinate2D   sendCoor;
/*点击的大头针*/
@property(nonatomic, strong)  BMKPointAnnotation * touchAnnotation;
/*输入框*/
@property(nonatomic, strong)  UITextField  *  searchTextField;
///*搜索的按钮*/
//@property(nonatomic, strong)  UIButton     *  searchBtn;
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


/** 好友发送的位置 */
@property(nonatomic, assign)  CLLocationCoordinate2D   friendCoord;

/** 搜索 */
@property(nonatomic, strong)  UISearchBar  *  searchBar;

/** 上面的View */
@property(nonatomic, strong)  UIView  *  topView;
/** 下面的View */
@property(nonatomic, strong)  XQQSearchTopVIew  *  typeView;

/** 下面的tableView */
@property(nonatomic, strong)  XQQSearchBottomTableView  *  bottomSearchTableView;

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
    //[self.view addSubview:self.searchBtn];
    [self.view addSubview:self.mapView];
    
    /*大头针*/
    BMKPointAnnotation * myAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D rr;
    rr.latitude = self.locationMessagebody.latitude;
    rr.longitude = self.locationMessagebody.longitude;
    myAnnotation.coordinate = rr;
    _sendCoor = rr;
    self.friendCoord = rr;
    myAnnotation.title = self.locationMessagebody.address;
    myAnnotation.subtitle = self.locationMessagebody.address;
    [_mapView addAnnotation:myAnnotation];
    [_mapView setCompassPosition:CGPointMake(180,200)];
    _locationService = [[BMKLocationService alloc]init];
    [_locationService startUserLocationService];
    [self initTwoView];
}

- (void)initTwoView{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, -100, iphoneWidth, 64)];
    self.topView.backgroundColor = XQQSingleColor(242);
    
    //返回按钮
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 27, 30, 30)];
    
    [backBtn addTarget:self action:@selector(topBackBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:XQQImageName(@"basenavigationbar_whiteArrow_withBg_normal") forState:UIControlStateNormal];
    [backBtn setImage:XQQImageName(@"basenavigationbar_whiteArrow_withBg_down") forState:UIControlStateHighlighted];
    [self.topView addSubview:backBtn];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame) + 10, 22, self.topView.frame.size.width - 30 - backBtn.frame.size.width, 40)];
    _searchBar.backgroundColor = [UIColor orangeColor];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    
    [self.topView addSubview:self.searchBar];
    
    [self.view addSubview:self.topView];
    
    self.typeView = [[XQQSearchTopVIew alloc]initWithFrame:CGRectMake(0, iphoneHeight, iphoneWidth, 200)];
    self.typeView.delegate = self;
    [self.view addSubview:self.typeView];
    
}


#pragma mark - historyCellDidPressDelegate
/** 历史记录tableView中cell点击 */
- (void)historyCellDidPress:(NSDictionary*)infoDict{
    [self startPOISearchWithKeyWord:infoDict[search_name]];
    [self hideSearchView];
}
#pragma mark - xqq_searchTopViewDelegate

/**搜索的item点击了*/
- (void)xqq_searchTopViewItemPress:(XQQCollectionViewCell *)item index:(NSInteger)index dataDict:(NSDictionary *)dataDict{
    
    [self startPOISearchWithKeyWord:dataDict[@"title"]];
    
    [self hideSearchView];
}
#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self showSearchView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self hideSearchView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString * searchStr = searchBar.text;
    
    [self startPOISearchWithKeyWord:searchStr];
    searchBar.text = @"";
    
    [self hideSearchView];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //弹出View
    [self showSearchView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self hideSearchView];
}
#pragma mark - xqq_searchDetailDelegate

/*搜索的详情视图呗点击了*/
- (void)searchDetailTableViewDidPress:(BMKPoiInfo *)info{
    [self.mapView setCenterCoordinate:info.pt animated:YES];
}


#pragma mark - activity

/** 显示搜索页面 */
- (void)showSearchView{
    [self.searchTextField resignFirstResponder];
    self.searchTextField.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [UIView animateWithDuration:.2f animations:^{
        self.topView.frame = CGRectMake(0, 0, iphoneWidth, 64);
        self.typeView.frame = CGRectMake(0, 64, iphoneWidth, 200);
    } completion:^(BOOL finished) {
        //判断是否有历史数据
        
        NSArray * history = [[XQQDataManager sharedDataManager] searchSearchHistory];
        if (1) {
            if (self.bottomSearchTableView) {
                [self.bottomSearchTableView removeFromSuperview];
                self.bottomSearchTableView = nil;
            }
            //创建下面的tableView
            self.bottomSearchTableView = [[XQQSearchBottomTableView alloc]initWithFrame:CGRectMake(0, self.typeView.xqq_bottom, iphoneWidth, iphoneHeight - self.typeView.xqq_height - self.topView.xqq_height)];
            self.bottomSearchTableView.dataArr = history;
            self.bottomSearchTableView.delegate = self;
            [self.view addSubview:self.bottomSearchTableView];
        }
    }];
}

/** 隐藏搜索页面 */
- (void)hideSearchView{
    self.navigationController.navigationBarHidden = NO;
    self.searchTextField.hidden = NO;
    [UIView animateWithDuration:.2f animations:^{
        self.topView.frame = CGRectMake(0, -100, iphoneWidth, 64);
        self.typeView.frame = CGRectMake(0, iphoneHeight, iphoneWidth, 200);
        [self.bottomSearchTableView removeFromSuperview];
        self.bottomSearchTableView = nil;
//        [self.detailTableView removeFromSuperview];
//        self.detailTableView = nil;
    } completion:^(BOOL finished) {
        [self.navigationController.view bringSubviewToFront:self.searchTextField];
        [self.searchBar resignFirstResponder];
    }];
}

/** 顶部退出按钮点击 */
- (void)topBackBtnDidPress:(UIButton*)button{
    [self hideSearchView];
}

/*全景*/
- (void)fullBtnDidPress{
    XQQPullViewController * pullVC = [[XQQPullViewController alloc]init];
    pullVC.coord = _sendCoor;
    [self.navigationController pushViewController:pullVC animated:YES];
}

- (void)lookPullBtnDidPress{
    //全景的controller
    
}
///*搜索按钮点击*/
//- (void)searchBtnDidPress{
//    //拿到输入框的值
//    NSString * searchStr = self.searchTextField.text;
//    //检索的参数信息类
//    BMKNearbySearchOption *baseSearch = [[BMKNearbySearchOption alloc]init];
//    baseSearch.keyword = searchStr;
//    baseSearch.location = _sendCoor;
//    baseSearch.radius = 5000;
//    baseSearch.sortType = BMK_POI_SORT_BY_DISTANCE;
//    BOOL flag = [_poiCodesearch poiSearchNearBy:baseSearch];
//    if(flag){
//        NSLog(@"反geo检索发送成功");
//    }
//    else{
//        NSLog(@"反geo检索发送失败");
//    }
//}
/** 选择出行方式 */
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
    
    UIAlertAction * cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //修改取消为红色
    [cancelAct setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    [alert addAction:driveAct];
    [alert addAction:workAct];
    [alert addAction:busAct];
    [alert addAction:cancelAct];
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

/**开始POI检索*/
- (void)startPOISearchWithKeyWord:(NSString*)keyWord{
    //开始检索POI信息
    [[XQQBaiduTool sharedBaiduTool] startPOISearch:self.friendCoord pageIndex:0 keyWord:keyWord complete:^(BMKPoiSearch *searcher, BMKPoiResult *poiResult, BMKSearchErrorCode errorCode) {
        if (errorCode == BMK_SEARCH_NO_ERROR) {
            NSLog(@"检索成功:---%@",poiResult.poiInfoList);
            
            //保存关键词到本地
            [self saveKeyWord:keyWord];
            //插大头针
            _poiResult = poiResult;
            [self.poiResultArr setArray:poiResult.poiInfoList];
            //添加大头针
            [self AddAnnotationViews];
            
        }else{
            NSLog(@"检索失败");
            [self.view hideToast];
            [self.view makeToast:@"检索失败" duration:1.f position:@"center"];
        }
    }];
}

/**保存关键字*/
- (void)saveKeyWord:(NSString*)keyWord{
    //取出时间
    NSDate * currentDate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = xqq_timeFormat;
    NSString * dateStr= [dateFormatter stringFromDate:currentDate];
    
    NSLog(@"当前时间---:%@",dateStr);
    
    [[XQQDataManager sharedDataManager] insertSearchHistory:@{search_name:keyWord,search_type:@"以后设置",search_time:dateStr}];
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

#pragma mark - setter&getter

- (BMKMapView *)mapView{
    
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
        _searchTextField.placeholder = @"在附近搜点什么吧~";
        _searchTextField.textAlignment = NSTextAlignmentCenter;
        
    }
    return _searchTextField;
}

//- (UIButton *)searchBtn{
//    if (!_searchBtn) {
//        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.searchTextField.frame)+10, self.searchTextField.frame.origin.y, 60, 44)];
//        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
//        [_searchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [_searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        [_searchBtn addTarget:self action:@selector(searchBtnDidPress) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _searchBtn;
//}
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
- (void)dealloc{
    
    _mapView.delegate = nil;
}

@end
