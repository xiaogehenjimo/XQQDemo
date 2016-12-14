//
//  XQQDetailLocationController.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/29.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface XQQDetailLocationController : UIViewController<BMKMapViewDelegate,BMKAnnotation,UITextFieldDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate>
/*地图*/
@property(nonatomic, strong)  BMKMapView  *  mapView;
/*位置消息体*/
@property(nonatomic, strong)  EMLocationMessageBody  *  locationMessagebody;

@end
