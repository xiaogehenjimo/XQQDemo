//
//  XQQChatLocationController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/28.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatLocationController.h"
#import "XQQLocationCell.h"
#import "XQQLocationTypeView.h"

@interface XQQChatLocationController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate,BMKMapViewDelegate,BMKAnnotation,typeButtonPressDelegate>
{
    BOOL isFirstLocation;
}

/*右上角发送 按钮*/
@property (nonatomic, strong)   UIButton * sendLocationBtn;
/*地图*/
@property (nonatomic, strong)   BMKMapView * mapView;
/*百度定位*/
@property (nonatomic, strong)   BMKLocationService * locService;
/*显示列表的tabelView*/
@property (nonatomic, strong)   UITableView * addressTabelView;
@property (nonatomic, strong)   NSMutableArray * addressDataArr;
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
/** 用户的位置 */
@property (nonatomic, assign)   CLLocationCoordinate2D   userLocation;
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
/** 定位按钮 */
@property (nonatomic, strong)   UIButton  *  locationBtn;
/** 当前页码 */
@property (nonatomic, assign)   NSInteger   currentPage;

/** 底部多种选择的view */
@property (nonatomic, strong)   XQQLocationTypeView  *  bottomTypeView;

/** 关键词 */
@property (nonatomic, copy)  NSString  *  keyWord;
/** 搜索的类型 */
@property(nonatomic, assign)  XQQLocationType   locationType;

@end

@implementation XQQChatLocationController
-(void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isCellClicked = NO;
    _currentRow = 0;
    _currentPage = 1;
    _keyWord = @"全部,综合,商场,美食";
    _locationType = XQQLocationTypeAll;
    [self initUI];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //开启定位
    isFirstLocation = YES;//首次定位
    self.currentSelectLocationIndex = 0;
    [_locService startUserLocationService];
    
}


- (void)initUI{
    self.navigationItem.title = @"选取位置";
    self.navigationItem.backBarButtonItem.title = @"返回";
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.sendLocationBtn];
        rightItem;
    });
    //初始化地图
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.centerImageView];
    
    [self.view addSubview:self.bottomTypeView];
    
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

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    [self.view hideToast];
    [self.view makeToast:@"定位失败,检查定位开关是否打开" duration:1.5f position:@"center"];
}
//定位成功
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
    _userLocation = ll;
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

/*加载更多的poi信息*/
- (void)loadMorePoiMessage:(CLLocationCoordinate2D)coordinate{
    
    [[XQQBaiduMapTool sharedTool] startPOISearch:self.currentCoordinate pageIndex:_currentPage keyWord:_keyWord complete:^(BMKPoiSearch *searcher, BMKPoiResult *poiResult, BMKSearchErrorCode errorCode) {
        if (errorCode == BMK_SEARCH_NO_ERROR) {
            [self.addressDataArr addObjectsFromArray:poiResult.poiInfoList];
            _currentRow = 0;
            [self refreshTableView];
            if (_currentPage < poiResult.pageNum) {
                _currentPage = poiResult.pageIndex + 1;
            }
        }else{
            [self.addressTabelView.mj_footer setState:MJRefreshStateNoMoreData];
            [self.addressTabelView.mj_footer endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.addressTabelView animated:YES];
        _isLoading = NO;
    }];
}

/** 刷新表格 */
- (void)refreshTableView{
    [self.addressTabelView reloadData];
    if (self.addressTabelView.mj_footer.isRefreshing) {
        [self.addressTabelView.mj_footer endRefreshing];
    }
}

- (void)startGeocodesearchWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    //[self.addressTabelView makeToastActivity];
    [MBProgressHUD showHUDAddedTo:self.addressTabelView animated:YES];
    
    if (self.locationType == XQQLocationTypeAll) {
        [[XQQBaiduMapTool sharedTool] startReverseGeoCodeSearch:coordinate complete:^(BMKGeoCodeSearch *searcher, BMKReverseGeoCodeResult *searchResult, BMKSearchErrorCode error) {
            if (error == BMK_SEARCH_NO_ERROR) {
                [self.addressDataArr removeAllObjects];
                [self.addressDataArr addObjectsFromArray:searchResult.poiList];
                //把当前定位信息自定义组装 放进数组首位
                BMKPoiInfo *first =[[BMKPoiInfo alloc]init];
                first.address = searchResult.address;
                first.name = [NSString stringWithFormat:@"[当前] %@",searchResult.sematicDescription];
                first.pt = searchResult.location;
                first.city = searchResult.addressDetail.city;
                [self.addressDataArr insertObject:first atIndex:0];
                _currentRow = 0;
                [self.addressTabelView reloadData];
                if (self.addressDataArr.count > 0) {
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.addressTabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
            [MBProgressHUD hideHUDForView:self.addressTabelView animated:YES];
            _isLoading = NO;
        }];
    }else{
        [[XQQBaiduMapTool sharedTool] startPOISearch:self.currentCoordinate pageIndex:0 keyWord:_keyWord complete:^(BMKPoiSearch *searcher, BMKPoiResult *poiResult, BMKSearchErrorCode errorCode) {
            if (errorCode == BMK_SEARCH_NO_ERROR) {
                [self.addressDataArr removeAllObjects];
                [self.addressDataArr addObjectsFromArray:poiResult.poiInfoList];
                _currentRow = 0;
                [self.addressTabelView reloadData];
                if (self.addressDataArr.count > 0) {
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.addressTabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                [MBProgressHUD hideHUDForView:self.addressTabelView animated:YES];
                _isLoading = NO;
            }else{
                [MBProgressHUD hideHUDForView:self.addressTabelView animated:YES];
                _isLoading = NO;
            }
        }];
    }
    
}

#pragma mark - typeButtonPressDelegate

- (void)typeDidPress:(UIButton *)button type:(XQQLocationType)type{
    _locationType = type;
    switch (type) {
        case XQQLocationTypeAll:{
            _keyWord = @"全部,综合,商场,美食";
        }
            break;
        case XQQLocationTypeShop:{
            _keyWord = @"学校";
        }
            break;
        case XQQLocationTypeHouse:{
            _keyWord = @"小区";
        }
            break;
        case XQQLocationTypeOffice:{
            _keyWord = @"写字楼";
        }
            break;
        default:
            break;
    }
    //开始地理编码
    [self startGeocodesearchWithCoordinate:self.currentCoordinate];
}

#pragma mark - activity

- (void)sendMyLocation{
    if (_sendModel == nil) {
        //发送第一条位置
        _sendModel = self.addressDataArr[0];
    }
    /** 地图截图 */
    //UIImage * tmpLocation =  [self.mapView takeSnapshot:CGRectMake(self.centerImageView.center.x - 100, self.centerImageView.center.y-100, 200, 200)];
    UIImage * tmpLocation = [self.mapView takeSnapshot];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMyLocationWithLocationModel:AndLocationImage:)]) {
        [self.delegate sendMyLocationWithLocationModel:self.sendModel AndLocationImage:tmpLocation];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*定位按钮点击了*/
- (void)locationBtnDidPress:(UIButton*)button{
    //移动地图的中心点到当前的定位点
    [self.mapView setCenterCoordinate:self.userLocation animated:YES];
}

#pragma mark - UITabelViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressDataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQLocationCell * cell = [XQQLocationCell cellForTableView:tableView indexPath:indexPath];
    BMKPoiInfo *model = self.addressDataArr[indexPath.row];
    if (indexPath.row != _currentRow) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if (indexPath.row == 0) {
        if (self.locationType == XQQLocationTypeAll) {
            NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:model.name];
            [attStr addAttribute:NSForegroundColorAttributeName value:XQQColor(61, 170, 249) range:NSMakeRange(0, 4)];
            cell.addressNameLabel.attributedText = attStr;
        }else{
            cell.addressNameLabel.text = model.name;
        }
    }else{
        cell.addressNameLabel.text = model.name;
    }
    cell.addressLabel.text = model.address;
    cell.addressLabel.textColor = [UIColor grayColor];
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

- (XQQLocationTypeView *)bottomTypeView{
    if (!_bottomTypeView) {
        _bottomTypeView = [[XQQLocationTypeView alloc]initWithFrame:CGRectMake(0, self.mapView.xqq_bottom, iphoneWidth, 50)];
        //_bottomTypeView.backgroundColor = [UIColor yellowColor];
        _bottomTypeView.delegate = self;
    }
    return _bottomTypeView;
}

- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, iphoneWidth, iphoneHeight * 0.5 - 50)];
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView.showMapScaleBar = YES;
        _mapView.showsUserLocation = YES;//显示定位图层
        _mapView.zoomLevel = 13.0;
        BMKLocationViewDisplayParam * parm = [[BMKLocationViewDisplayParam alloc]init];
        parm.isAccuracyCircleShow = NO;
        [_mapView updateLocationViewWithParam:parm];
        //调整logo位置
        _mapView.logoPosition = BMKLogoPositionRightBottom;
        //添加按钮
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(_mapView.xqq_width - 40 - 10, _mapView.xqq_height - 25 - 40, 40, 40)];
        [button setImage:[UIImage imageNamed:@"location_my"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"location_my_current"] forState:UIControlStateHighlighted];
        [_mapView addSubview:button];
        [button addTarget:self action:@selector(locationBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        self.locationBtn = button;
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
        _addressTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomTypeView.frame)+3, iphoneWidth, iphoneHeight - 3 - 64 - self.mapView.frame.size.height- self.bottomTypeView.xqq_height) style:UITableViewStylePlain];
        _addressTabelView.delegate = self;
        _addressTabelView.dataSource = self;
        _addressTabelView.tableHeaderView = self.headView;
        _addressTabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePoiMessage:)];
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


@end
