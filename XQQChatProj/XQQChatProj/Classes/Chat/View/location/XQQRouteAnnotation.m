//
//  XQQRouteAnnotation.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/12.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQRouteAnnotation.h"
#import "UIImage-Extensions.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@implementation XQQRouteAnnotation
@synthesize type = _type;
@synthesize degree = _degree;


- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview
{
    BMKAnnotationView* view = nil;
    switch (_type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"nav_start"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"nav_end"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"nav_bus"];
            }
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"nav_rail"];
            }
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"route_node"];
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageNamed:@"direction"];
            view.image = [image imageRotatedByDegrees:_degree];
            view.image = image;
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"waypoint_node"];
            } else {
                [view setNeedsDisplay];
            }
            UIImage* image = [UIImage imageNamed:@"nav_waypoint"];
            view.image = [image imageRotatedByDegrees:_degree];
            view.image = image;
        }
            break;
            
        case 6:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"stairs_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"stairs_node"];
            }
            view.image = [UIImage imageNamed:@"direction"];
        }
            break;
        default:
            break;
    }
    if (view) {
        view.annotation = self;
        view.canShowCallout = YES;
    }
    return view;
}
@end
