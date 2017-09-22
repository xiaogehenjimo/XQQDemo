//
//  UIImageView+YT_SingleClick.h
//  KDS_Phone
//
//  Created by xuqinqiang on 2017/9/1.
//  Copyright © 2017年 kds. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YT_ImageClickBlock)();

@interface UIImageView (YT_SingleClicke)

@property (nonatomic, copy)  YT_ImageClickBlock  clickedBlock;

@end
