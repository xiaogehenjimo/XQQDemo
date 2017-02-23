//
//  XQQCollectionViewCell.h
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/12.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQQCollectionViewCell;

@protocol collectionItemPressDelegate <NSObject>

- (void)collectionItemDidPress:(NSInteger)index
                      dataDict:(NSDictionary*)dataDict
                          item:(XQQCollectionViewCell*)item;

@end


@interface XQQCollectionViewCell : UICollectionViewCell

/** 代理 */
@property (nonatomic, weak)  id<collectionItemPressDelegate>  delegate;
/** 数据字典 */
@property(nonatomic, strong)  NSDictionary  *  dataDict;
/** 标记 */
@property(nonatomic, assign)  NSInteger   index;

@end
