//
//  XQQSearchPaopaoView.m
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/16.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQSearchPaopaoView.h"

@interface XQQSearchPaopaoView ()
/**全景按钮*/
@property(nonatomic, strong)  UIButton  *  panoramaBtn;


@end


@implementation XQQSearchPaopaoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor orangeColor];
        [self initUI];
        
        
    }
    return self;
}

/*初始化UI*/
- (void)initUI{
    self.panoramaBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 44)];
    self.panoramaBtn.backgroundColor = [UIColor redColor];
    [self.panoramaBtn addTarget:self action:@selector(panoramaBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    //self.panoramaBtn.hidden = YES;
    [self addSubview:self.panoramaBtn];
}

/*全景按钮点击了*/
- (void)panoramaBtnDidPress:(UIButton*)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(paoPaoViewDidPress:)]) {
        [self.delegate paoPaoViewDidPress:self.dataModel];
    }
}

- (void)setDataModel:(BMKPoiInfo *)dataModel{
    _dataModel = dataModel;
    
   // NSLog(@"是否支持全景----%d",dataModel.panoFlag);
    
    //self.panoramaBtn.hidden = !dataModel.panoFlag;
    
    
    
}

@end
