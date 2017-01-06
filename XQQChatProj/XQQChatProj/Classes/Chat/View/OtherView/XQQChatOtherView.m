//
//  XQQChatOtherView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatOtherView.h"
#import "XQQOtherBtn.h"
#define boardWidth 30

@interface XQQChatOtherView ()
/*图片*/
@property(nonatomic, strong)  XQQOtherBtn  *  picBtn;
/** 拍摄 */
@property(nonatomic, strong)  XQQOtherBtn  *  filmBtn;
/** 位置 */
@property(nonatomic, strong)  XQQOtherBtn  *  locationBtn;

@end

@implementation XQQChatOtherView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //初始化四个按钮
        CGFloat btnWidth = (iphoneWidth - 5 * boardWidth)/4;
        CGFloat btnHeight = btnWidth + 20;
        NSArray * titleArr = @[@"图片",@"拍摄",@"位置"];
        NSArray * imageArr = @[@"Fav_Note_ToolBar_Album",@"Fav_Note_ToolBar_Camera",@"Fav_Note_ToolBar_Location"];
        for (NSInteger i = 0; i < titleArr.count; i ++) {
            XQQOtherBtn * button = [[XQQOtherBtn alloc]initWithFrame:CGRectMake(boardWidth + i * (btnWidth +boardWidth), 30, btnWidth, btnHeight)];
            button.tag = 1888888 + i;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_HL",imageArr[i]]] forState:UIControlStateHighlighted];
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(otherBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.picBtn = button;
            }else if(i == 1){
                self.filmBtn = button;
            }else if (i == 2){
                self.locationBtn = button;
            }
            [self addSubview:button];
        }
    }
    return self;
}

- (void)otherBtnDidPress:(XQQOtherBtn*)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BtnDidPress:)]) {
        [self.delegate BtnDidPress:button.tag - 1888888];
    }
}
@end
