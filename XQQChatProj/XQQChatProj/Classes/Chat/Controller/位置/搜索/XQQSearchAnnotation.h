//
//  XQQSearchAnnotation.h
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/16.
//  Copyright © 2017年 UIP. All rights reserved.
//


@class BMKPoiInfo;

@interface XQQSearchAnnotation : BMKPointAnnotation

/** 数据模型 */
@property(nonatomic, strong)  BMKPoiInfo  *  dataModel;

@end
