//
//  XQQSearchBottomTableView.h
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/13.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol historyCellDidPressDelegate <NSObject>

- (void)historyCellDidPress:(NSDictionary*)infoDict;

@end


@interface XQQSearchBottomTableView : UIView

/** 数据源 */
@property(nonatomic, strong)  NSArray  *  dataArr;
/** 代理 */
@property(nonatomic, weak)  id<historyCellDidPressDelegate> delegate;
@end
