//
//  XQQBaiduTool.h
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/11.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

/*定位结束的block*/
typedef void(^xqq_locationComplete)(BMKUserLocation * userLocation,NSError * error);

/*poi搜索完成的block*/
typedef void(^POISearchCompleteBlock)(BMKPoiSearch *searcher, BMKPoiResult *poiResult,BMKSearchErrorCode errorCode);

/*poi详情搜索返回的block*/
typedef void(^POIDetailCompleteBlock)(BMKPoiSearch*searcher,BMKPoiDetailResult*poiDetailResult,BMKSearchErrorCode errorCode);

/*反地理编码*/
typedef void(^ReverseSearchCompleteBlock)(BMKGeoCodeSearch *searcher, BMKReverseGeoCodeResult*searchResult,BMKSearchErrorCode error);

/*地理编码*/
typedef void(^geoSearchCompleteBlock)(BMKGeoCodeSearch *searcher, BMKGeoCodeResult*searchResult,BMKSearchErrorCode error);


@interface XQQBaiduTool : NSObject

/*获取操作实例对象*/
+ (instancetype)sharedBaiduTool;

/*开始定位*/
- (void)xqq_startLocationCompleteBlock:(xqq_locationComplete)completeBlock;

/*开始poi检索*/
- (void)startPOISearch:(CLLocationCoordinate2D)coord
             pageIndex:(NSInteger)pageIndex
               keyWord:(NSString*)keyWord
              complete:(POISearchCompleteBlock)complete;
/*开始poi详情检索*/
- (void)startPOIDetailSearchWithUid:(NSString*)uid
                      completeBlock:(POIDetailCompleteBlock)completeBlock;

/*反地理编码(经纬度---> 详细地址)*/
- (void)startReverseGeoCodeSearch:(CLLocationCoordinate2D)coord
                         complete:(ReverseSearchCompleteBlock)complete;

/*地理编码(详细地址---> 经纬度)*/
- (void)startGeoCodeSearch:(NSString*)address
                  complete:(geoSearchCompleteBlock)complete;
@end
