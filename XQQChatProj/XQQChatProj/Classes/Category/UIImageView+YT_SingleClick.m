//
//  UIImageView+YT_SingleClick.m
//  KDS_Phone
//
//  Created by xuqinqiang on 2017/9/1.
//  Copyright © 2017年 kds. All rights reserved.
//

#import "UIImageView+YT_SingleClick.h"
#import <objc/runtime.h>

static void * YT_SingleClick_Property = @"YT_imageViewActionKey";

@implementation UIImageView (YT_SingleClicke)

@dynamic clickedBlock;

- (void)setClickedBlock:(YT_ImageClickBlock)clickedBlock{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction)];
    [self addGestureRecognizer:sigleTap];
    objc_setAssociatedObject(self, &YT_SingleClick_Property, clickedBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YT_ImageClickBlock)clickedBlock{
    return objc_getAssociatedObject(self, &YT_SingleClick_Property);
}

- (void)imageAction{
    YT_ImageClickBlock clickBlock = objc_getAssociatedObject(self, &YT_SingleClick_Property);
    if (clickBlock) {
        clickBlock();
    }
}

@end
