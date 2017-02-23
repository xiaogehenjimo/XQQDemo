//
//  XQQSearchTopVIew.h
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/12.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XQQCollectionViewCell;
@protocol xqq_searchTopViewDelegate <NSObject>

- (void)xqq_searchTopViewItemPress:(XQQCollectionViewCell*)item index:(NSInteger)index dataDict:(NSDictionary*)dataDict;

@end

@interface XQQSearchTopVIew : UIView

/** 代理 */
@property (nonatomic, weak)  id<xqq_searchTopViewDelegate>  delegate;


@end
