//
//  XQQBaiduMapTool.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/13.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ReverseSearchCompleteBlock)(BMKGeoCodeSearch *searcher, BMKReverseGeoCodeResult*searchResult,BMKSearchErrorCode error);

typedef void(^geoSearchCompleteBlock)(BMKGeoCodeSearch *searcher, BMKGeoCodeResult*searchResult,BMKSearchErrorCode error);


@interface XQQBaiduMapTool : NSObject
/** 反地理完成的block */
@property (nonatomic, copy)  ReverseSearchCompleteBlock  ReverseCompleteBlock;
/** 地理编码完成的block */
@property (nonatomic, copy)  geoSearchCompleteBlock  geoCompleteBlock;



+ (instancetype)sharedTool;

/*反地理编码(把经纬度---> 详细地址)*/
- (void)startReverseGeoCodeSearch:(CLLocationCoordinate2D)coord
                         complete:(ReverseSearchCompleteBlock)complete;
/*地理编码(详细地址---> 经纬度)*/
- (void)startGeoCodeSearch:(NSString*)address
                  complete:(geoSearchCompleteBlock)complete;


@end
