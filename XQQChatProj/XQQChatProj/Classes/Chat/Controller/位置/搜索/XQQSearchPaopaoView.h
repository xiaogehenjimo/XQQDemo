//
//  XQQSearchPaopaoView.h
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/16.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol xqq_paoPaoViewDelegate <NSObject>

- (void)paoPaoViewDidPress:(BMKPoiInfo*)poiInfo;

@end


@interface XQQSearchPaopaoView : UIView
/** 数据模型 */
@property(nonatomic, strong)  BMKPoiInfo  *  dataModel;
/** 代理 */
@property (nonatomic, weak)  id<xqq_paoPaoViewDelegate>  delegate;

@end
