//
//  XQQSearchDetailTableView.h
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/16.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol xqq_searchDetailDelegate <NSObject>

- (void)searchDetailTableViewDidPress:(BMKPoiInfo*)info;

@end


@interface XQQSearchDetailTableView : UIView

/** 数据源 */
@property(nonatomic, strong)  NSArray  *  dataArr;
/** 代理 */
@property(nonatomic, weak)  id<xqq_searchDetailDelegate>   delegate;



@end
