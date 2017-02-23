//
//  XQQBaiduTool.m
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/11.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQBaiduTool.h"


#define searchRadius 1500 //检索的半径
#define searchCount  20   //检索每页返回的个数

@interface XQQBaiduTool ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
/** 定位 */
@property (nonatomic, strong) BMKLocationService * locationService;
/** 定位结束的block */
@property (nonatomic, copy)  xqq_locationComplete  locationComplete;
/** 地理编码 */
@property (nonatomic, strong)  BMKGeoCodeSearch  * searcher;
/** 反地理完成的block */
@property (nonatomic, copy)  ReverseSearchCompleteBlock  ReverseCompleteBlock;
/** 地理编码完成的block */
@property (nonatomic, copy)  geoSearchCompleteBlock  geoCompleteBlock;
/** poi搜索 */
@property (nonatomic, strong)  BMKPoiSearch  *  poiSearch;
/** poi搜索完成的block */
@property (nonatomic, copy)  POISearchCompleteBlock  poiCompleteBlock;
/** poi详情搜索的block */
@property (nonatomic, copy)  POIDetailCompleteBlock  poiDetailBlock;

@end

@implementation XQQBaiduTool

/*获取操作实例对象*/
+ (instancetype)sharedBaiduTool{
    static XQQBaiduTool * tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[XQQBaiduTool alloc]init];
    });
    return tool;
}

#pragma mark - 定位相关

/*开始定位*/
- (void)xqq_startLocationCompleteBlock:(xqq_locationComplete)completeBlock{
    if (completeBlock) {
        self.locationComplete = completeBlock;
        self.locationService = nil;
        self.locationService = [[BMKLocationService alloc]init];
        self.locationService.delegate = nil;
        self.locationService.delegate = self;
        [self.locationService startUserLocationService];
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (self.locationComplete) {
        self.locationComplete(userLocation,nil);
        [self.locationService stopUserLocationService];
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    if (self.locationComplete) {
        self.locationComplete(nil,error);
        [self.locationService stopUserLocationService];
    }
}

#pragma mark - POI检索
/*开始poi检索*/
- (void)startPOISearch:(CLLocationCoordinate2D)coord
             pageIndex:(NSInteger)pageIndex
               keyWord:(NSString*)keyWord
              complete:(POISearchCompleteBlock)complete{
    if (complete) {
        self.poiCompleteBlock = complete;
        self.poiSearch = nil;
        self.poiSearch = [[BMKPoiSearch alloc]init];
        self.poiSearch.delegate = nil;
        self.poiSearch.delegate = self;
        CLLocationCoordinate2D pt = coord;
        BMKNearbySearchOption * option = [[BMKNearbySearchOption alloc]init];
        option.keyword = keyWord;
        option.location = pt;
        option.pageCapacity = searchCount;
        option.radius = searchRadius;
        option.sortType = BMK_POI_SORT_BY_DISTANCE;
        option.pageIndex = (int)pageIndex;
        BOOL flag = [self.poiSearch  poiSearchNearBy:option];
        if(flag)
        {
            NSLog(@"poi检索发送成功");
        }
        else
        {
            NSLog(@"poi检索发送失败");
        }
    }
}

/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (self.poiCompleteBlock) {
        self.poiCompleteBlock(searcher,poiResult,errorCode);
    }
}


/*开始poi详情检索*/
- (void)startPOIDetailSearchWithUid:(NSString*)uid
                      completeBlock:(POIDetailCompleteBlock)completeBlock{
    if (completeBlock) {
        self.poiDetailBlock = completeBlock;
        self.poiSearch = nil;
        self.poiSearch = [[BMKPoiSearch alloc]init];
        self.poiSearch.delegate = nil;
        self.poiSearch.delegate = self;
        BMKPoiDetailSearchOption * detailOption = [[BMKPoiDetailSearchOption alloc]init];
        detailOption.poiUid = uid;
        BOOL flag = [self.poiSearch poiDetailSearch:detailOption];
        if (flag) {
            NSLog(@"详情检索发送成功");
        }else{
            NSLog(@"详情检索发送失败");
        }
    }
}

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    if (self.poiDetailBlock) {
        self.poiDetailBlock(searcher,poiDetailResult,errorCode);
    }
}

#pragma mark - 地理编码与反编码

/*反地理编码(经纬度---> 详细地址)*/
- (void)startReverseGeoCodeSearch:(CLLocationCoordinate2D)coord
                         complete:(ReverseSearchCompleteBlock)complete{
    if (complete) {
        self.ReverseCompleteBlock = complete;
        self.searcher = nil;
        self.searcher = [[BMKGeoCodeSearch alloc]init];
        self.searcher.delegate = nil;
        self.searcher.delegate = self;
        //发起反向地理编码检索
        CLLocationCoordinate2D pt = coord;
        BMKReverseGeoCodeOption * reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
    }
}

/*地理编码(详细地址---> 经纬度)*/
- (void)startGeoCodeSearch:(NSString*)address
                  complete:(geoSearchCompleteBlock)complete{
    if (complete) {
        self.geoCompleteBlock = complete;
        self.searcher = nil;
        self.searcher = [[BMKGeoCodeSearch alloc]init];
        self.searcher.delegate = nil;
        self.searcher.delegate = self;
        BMKGeoCodeSearchOption * geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.city = [address substringWithRange:NSMakeRange(0, 3)];
        geoCodeSearchOption.address = [address substringWithRange:NSMakeRange(2, address.length - 1)];
        BOOL flag = [self.searcher geoCode:geoCodeSearchOption];
        if(flag){
            NSLog(@"geo检索发送成功");
        }else{
            NSLog(@"geo检索发送失败");
        }
    }
}

/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher
                    result:(BMKGeoCodeResult *)result
                 errorCode:(BMKSearchErrorCode)error{
    if (self.geoCompleteBlock) {
        self.geoCompleteBlock(searcher,result,error);
    }
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (self.ReverseCompleteBlock) {
        self.ReverseCompleteBlock(searcher,result,error);
    }
}
@end
