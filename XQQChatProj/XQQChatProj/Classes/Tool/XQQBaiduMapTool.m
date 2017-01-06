//
//  XQQBaiduMapTool.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/13.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQBaiduMapTool.h"

@interface XQQBaiduMapTool ()<BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>

/** 地理编码 */
@property(nonatomic, strong)  BMKGeoCodeSearch  * searcher;
/** poi搜索 */
@property(nonatomic, strong)  BMKPoiSearch  *  poiSearch;

@end


@implementation XQQBaiduMapTool

+ (instancetype)sharedTool{
    static dispatch_once_t once;
    static XQQBaiduMapTool * tool = nil;
    dispatch_once(&once, ^{
        tool = [[XQQBaiduMapTool alloc]init];
    });
    return tool;
}


/*开始poi检索*/
- (void)startPOISearch:(CLLocationCoordinate2D)coord
             pageIndex:(NSInteger)pageIndex
               keyWord:(NSString*)keyWord
              complete:(POISearchCompleteBlock)complete{
    if (complete) {
        self.poiCompleteBlock = complete;
        _poiSearch = [[BMKPoiSearch alloc]init];
        _poiSearch.delegate = nil;
        _poiSearch.delegate = self;
        CLLocationCoordinate2D pt = coord;
        BMKNearbySearchOption * option = [[BMKNearbySearchOption alloc]init];
        option.keyword = keyWord;
        option.location = pt;
        option.pageCapacity = 15;
        option.radius = 1500;//1KM范围
        option.sortType = BMK_POI_SORT_BY_DISTANCE;
        option.pageIndex = (int)pageIndex;
        BOOL flag = [_poiSearch  poiSearchNearBy:option];
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



/*反地理编码(经纬度---> 详细地址)*/
- (void)startReverseGeoCodeSearch:(CLLocationCoordinate2D)coord
                         complete:(ReverseSearchCompleteBlock)complete{
    if (complete) {
        self.ReverseCompleteBlock = complete;
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = nil;
        _searcher.delegate = self;
        //发起反向地理编码检索
        CLLocationCoordinate2D pt = coord;
        BMKReverseGeoCodeOption * reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
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
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = nil;
        _searcher.delegate = self;
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.city= [address substringWithRange:NSMakeRange(0, 3)];
        geoCodeSearchOption.address = [address substringWithRange:NSMakeRange(2, address.length - 1)];
        BOOL flag = [_searcher geoCode:geoCodeSearchOption];
        if(flag)
        {
            NSLog(@"geo检索发送成功");
        }
        else
        {
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
    if (_geoCompleteBlock) {
        _geoCompleteBlock(searcher,result,error);
    }
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (_ReverseCompleteBlock) {
        _ReverseCompleteBlock(searcher,result,error);
    }
}

@end
