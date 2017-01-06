//
//  XQQBaiduMapTool.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/13.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>


/*poi搜索完成的block*/
typedef void(^POISearchCompleteBlock)(BMKPoiSearch *searcher, BMKPoiResult *poiResult,BMKSearchErrorCode errorCode);

/*反地理编码*/
typedef void(^ReverseSearchCompleteBlock)(BMKGeoCodeSearch *searcher, BMKReverseGeoCodeResult*searchResult,BMKSearchErrorCode error);

/*地理编码*/
typedef void(^geoSearchCompleteBlock)(BMKGeoCodeSearch *searcher, BMKGeoCodeResult*searchResult,BMKSearchErrorCode error);


@interface XQQBaiduMapTool : NSObject

/** poi搜索完成的block */
@property (nonatomic, copy)  POISearchCompleteBlock  poiCompleteBlock;

/** 反地理完成的block */
@property (nonatomic, copy)  ReverseSearchCompleteBlock  ReverseCompleteBlock;
/** 地理编码完成的block */
@property (nonatomic, copy)  geoSearchCompleteBlock  geoCompleteBlock;



+ (instancetype)sharedTool;
/*开始poi检索*/
- (void)startPOISearch:(CLLocationCoordinate2D)coord
             pageIndex:(NSInteger)pageIndex
               keyWord:(NSString*)keyWord
              complete:(POISearchCompleteBlock)complete;

/*反地理编码(经纬度---> 详细地址)*/
- (void)startReverseGeoCodeSearch:(CLLocationCoordinate2D)coord
                         complete:(ReverseSearchCompleteBlock)complete;
/*地理编码(详细地址---> 经纬度)*/
- (void)startGeoCodeSearch:(NSString*)address
                  complete:(geoSearchCompleteBlock)complete;


@end
