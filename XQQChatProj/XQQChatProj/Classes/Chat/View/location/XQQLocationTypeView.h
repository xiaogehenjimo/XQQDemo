//
//  XQQLocationTypeView.h
//  XQQChatProj
//
//  Created by XQQ on 2017/1/6.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XQQLocationType){
    XQQLocationTypeAll = 0,
    XQQLocationTypeOffice,
    XQQLocationTypeHouse,
    XQQLocationTypeShop
};

@protocol typeButtonPressDelegate <NSObject>

- (void)typeDidPress:(UIButton*)button type:(XQQLocationType)type;

@end

@interface XQQLocationTypeView : UIView

/** 代理 */
@property(nonatomic, weak)  id<typeButtonPressDelegate> delegate;


/**
 创建类型view

 @param frame frame
 @param titleArr 需要传递的标题数组
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray*)titleArr;

@end
