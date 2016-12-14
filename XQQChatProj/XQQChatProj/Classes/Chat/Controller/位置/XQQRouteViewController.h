//
//  XQQRouteViewController.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/13.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
enum routeType{
    XQQRouteTypeWalk = 0,
    XQQRouteTypeDrive,
    XQQRouteTypeBus
};

@interface XQQRouteViewController : UIViewController

/** 路径规划类型 */
@property(nonatomic, assign)  enum routeType   routeType;
/** 目的地经纬度 */
@property(nonatomic, assign)  CLLocationCoordinate2D   endCoord;
/** 我的位置 */
@property(nonatomic, assign)  CLLocationCoordinate2D   myCoord;
/** 我的城市 */
@property (nonatomic, copy)  NSString  *  myCity;
@end
