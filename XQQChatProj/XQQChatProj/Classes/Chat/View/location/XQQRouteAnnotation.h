//
//  XQQRouteAnnotation.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/12.
//  Copyright © 2016年 UIP. All rights reserved.
//


#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface XQQRouteAnnotation : BMKPointAnnotation
///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点  6:楼梯、电梯
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger degree;
//获取该RouteAnnotation对应的BMKAnnotationView
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview;
@end
