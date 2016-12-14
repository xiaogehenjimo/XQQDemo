//
//  XQQChatLocationController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/28.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatLocationController.h"
#import "XQQLocationCell.h"

@interface XQQChatLocationController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate,BMKAnnotation>
{
    BOOL isFirstLocation;
}
/*定位*/
@property (nonatomic, strong)   CLLocationManager * CLlocationManager;
/*右上角发送 按钮*/
@property (nonatomic, strong)   UIButton * sendLocationBtn;
/*地图*/
@property (nonatomic, strong)   BMKMapView * mapView;
/*百度定位*/
@property (nonatomic, strong)   BMKLocationService * locService;
/*显示列表的tabelView*/
@property (nonatomic, strong)   UITableView * addressTabelView;
@property (nonatomic, strong)   NSMutableArray * addressDataArr;
/*geo搜索*/
@property (nonatomic, strong)   BMKGeoCodeSearch * geocodesearch;
/*是否为第一次定位*/
@property (nonatomic, assign)   BOOL isFirstLocation;
/*记录当前的经纬度*/
@property (nonatomic, assign)   CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, assign)   NSInteger currentSelectLocationIndex;
/*记录打对勾的一行*/
@property (nonatomic, assign)   NSInteger    currentRow;
/*记录要发送的Model*/
@property (nonatomic, strong)   BMKPoiInfo  *  sendModel;
/*当前地图的中心点*/
@property (nonatomic, assign)   CLLocationCoordinate2D centerCoordinate;
/*大头针*/
@property (nonatomic, strong)   BMKPointAnnotation  * Annotation;
/*中心点imageView*/
@property (nonatomic, strong)   UIImageView  *  centerImageView;
/*tabelView头视图*/
@property (nonatomic, strong)   UIView  *  headView;
/*区别是否点击了cell*/
@property (nonatomic, assign)   BOOL   isCellClicked;
/*记录poi搜索状态*/
@property (nonatomic, assign)   BOOL   isLoading;
@end

@implementation XQQChatLocationController
-(void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
    self.geocodesearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
    self.geocodesearch.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isCellClicked = NO;
    _currentRow = 0;
    self.navigationItem.title = @"选取位置";
    self.navigationItem.backBarButtonItem.title = @"返回";
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.sendLocationBtn];
        rightItem;
    });
    //初始化地图
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.centerImageView];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //开启定位
    isFirstLocation = YES;//首次定位
    self.currentSelectLocationIndex = 0;
    [_locService startUserLocationService];
    [self.view addSubview:self.addressTabelView];
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (_isCellClicked) {
        _isCellClicked = NO;
        return;
    }
    _isCellClicked = NO;
    if (!isFirstLocation)
    {
        //将view的坐标转换成地图的坐标
        CLLocationCoordinate2D tt =[mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
        /*给中点imageView添加动画*/
        CGRect tmpRect = self.centerImageView.frame;
        [UIView animateWithDuration:.3f animations:^{
            self.centerImageView.frame = CGRectMake(tmpRect.origin.x, tmpRect.origin.y - 15, tmpRect.size.width, tmpRect.size.height);
            
        } completion:^(BOOL finished) {
            CGRect tmpRect = self.centerImageView.frame;
            
            [UIView animateWithDuration:.3f animations:^{
                self.centerImageView.frame = CGRectMake(tmpRect.origin.x, tmpRect.origin.y + 15, tmpRect.size.width, tmpRect.size.height);
            } completion:^(BOOL finished) {
                //将转换的地图坐标赋值给
                self.currentCoordinate=tt;
            }];
        }];
    }
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    NSLog(@"heading is %@",userLocation.heading);
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    [self.view hideToast];
    [self.view makeToast:@"定位失败,检查定位开关是否打开" duration:1.5f position:@"center"];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    isFirstLocation = NO;
    //拿到经纬度
    self.currentCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
    BMKLocationViewDisplayParam * param = [[BMKLocationViewDisplayParam alloc]init];
    param.locationViewImgName = @"icon_center_point";
    [_mapView updateLocationViewWithParam:param];
    CLLocationCoordinate2D ll = userLocation.location.coordinate;
    //放大到标注的位置
    BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance(ll, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
    [_locService stopUserLocationService];
}


- (void)setCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate{
    _currentCoordinate = currentCoordinate;
    if (_isCellClicked) {
        _isCellClicked = NO;
    }else{
        if (_isLoading) {
            return;
        }
        _isLoading = YES;
        [self startGeocodesearchWithCoordinate:currentCoordinate];
    }
}

- (void)startGeocodesearchWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.addressTabelView makeToastActivity];
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - BMKGeoCodeSearchDelegate

/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"返回地址信息搜索结果,失败-------------");
    [self.addressTabelView hideToastActivity];
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        [self.addressDataArr removeAllObjects];
        [self.addressDataArr addObjectsFromArray:result.poiList];
        //把当前定位信息自定义组装 放进数组首位
        BMKPoiInfo *first =[[BMKPoiInfo alloc]init];
        first.address = result.address;
        first.name = @"";
        first.pt = result.location;
        first.city = result.addressDetail.city;
        [self.addressDataArr insertObject:first atIndex:0];
        _currentRow = 0;
        [self.addressTabelView reloadData];
        if (self.addressDataArr.count > 0) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.addressTabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    [self.addressTabelView hideToastActivity];
    _isLoading = NO;
}


#pragma mark - activity

- (void)sendMyLocation{
    if (_sendModel == nil) {
        //发送第一条位置
        _sendModel = self.addressDataArr[0];
    }
    /*截图*/
    //UIImage * tmpLocation =  [self.mapView takeSnapshot:CGRectMake(self.centerImageView.center.x - 100, self.centerImageView.center.y-100, 200, 200)];
    UIImage * tmpLocation = [self.mapView takeSnapshot];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMyLocationWithLocationModel:AndLocationImage:)]) {
        [self.delegate sendMyLocationWithLocationModel:self.sendModel AndLocationImage:tmpLocation];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITabelViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressDataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * idenStr = @"str";
    XQQLocationCell * cell = [tableView dequeueReusableCellWithIdentifier:idenStr];
    if (!cell) {
        cell = [[XQQLocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenStr];
    }
    BMKPoiInfo *model = self.addressDataArr[indexPath.row];
    if (indexPath.row != _currentRow) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.addressNameLabel.text = model.name;
    cell.addressLabel.text = model.address;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _sendModel= self.addressDataArr[indexPath.row];
    _currentRow = indexPath.row;
    _isCellClicked = YES;
    self.mapView.centerCoordinate = _sendModel.pt;
    [self.addressTabelView reloadData];
}

#pragma mark - setter&getter
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return _headView;
}
- (CLLocationManager *)CLlocationManager{
    if (!_CLlocationManager) {
        _CLlocationManager = [[CLLocationManager alloc]init];
        _CLlocationManager.delegate = self;
    }
    return _CLlocationManager;
}

- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, iphoneWidth, iphoneHeight - 64 - 300)];
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView.showMapScaleBar = YES;
        _mapView.showsUserLocation = YES;//显示定位图层
        _mapView.zoomLevel = 13.0;
        [_mapView setCompassPosition:CGPointMake(180, 200)];
    }
    return _mapView;
}
- (UIButton *)sendLocationBtn{
    if (!_sendLocationBtn) {
        _sendLocationBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0,3, 40,40);
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:@"发送" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(sendMyLocation) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _sendLocationBtn;
}

- (NSMutableArray *)addressDataArr{
    if (!_addressDataArr) {
        _addressDataArr = [[NSMutableArray alloc]init];
    }
    return _addressDataArr;
}

- (UITableView *)addressTabelView{
    if (!_addressTabelView) {
        _addressTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame)+3, iphoneWidth, iphoneHeight - 3 - 64 - self.mapView.frame.size.height) style:UITableViewStylePlain];
        _addressTabelView.delegate = self;
        _addressTabelView.dataSource = self;
        _addressTabelView.tableHeaderView = self.headView;
    }
    return _addressTabelView;
}
- (UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.mapView.center.x-15, self.mapView.center.y-15, 30, 30)];
        _centerImageView.center = self.mapView.center;
        _centerImageView.image = [UIImage imageNamed:@"pin_purple@2x.png"];
    }
    return _centerImageView;
}

//geo搜索
- (BMKGeoCodeSearch*)geocodesearch{
    if (_geocodesearch == nil){
        _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    }
    return _geocodesearch;
}

@end
