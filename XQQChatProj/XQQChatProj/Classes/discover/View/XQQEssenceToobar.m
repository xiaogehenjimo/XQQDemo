//
//  XQQEssenceToobar.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQEssenceToobar.h"

@interface XQQEssenceToobar ()
/** 里面存放所有分割线 */
@property(nonatomic, strong)  NSMutableArray  *  dividerArr;
/** 里面存放所有的按钮 */
@property(nonatomic, strong)  NSMutableArray  * buttonArr;
/** 赞 */
@property(nonatomic, strong)  UIButton        *  supportBtn;
/** 踩 */
@property(nonatomic, strong)  UIButton        *  stampBtn;
/** 转发 */
@property(nonatomic, strong)  UIButton        *  repeatBtn;
/** 评论 */
@property(nonatomic, strong)  UIButton        *  commentBtn;

@end


@implementation XQQEssenceToobar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XQQColor(246, 246, 246);
        //添加按钮
        self.supportBtn = [self setUpButtonWithTitle:@"" icon:@"mainCellDing" hlightImage:@"mainCellDingClick" tag:10081];
        self.stampBtn = [self setUpButtonWithTitle:@"" icon:@"mainCellCai" hlightImage:@"mainCellCaiClick" tag:10082];
        self.repeatBtn = [self setUpButtonWithTitle:@"" icon:@"mainCellShare" hlightImage:@"mainCellShareClick"
                                                tag:10083];
        self.commentBtn =  [self setUpButtonWithTitle:@"" icon:@"mainCellComment" hlightImage:@"mainCellCommentClick" tag:10084];
        //添加分割线
        [self setUpDivider];
        [self setUpDivider];
        [self setUpDivider];
        
    }
    return self;
}
/**
 *  添加分割线
 */
- (void)setUpDivider{
    UIImageView * divider = [[UIImageView alloc]init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    [self.dividerArr addObject:divider];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //设置frame
    NSInteger buttonCount = self.buttonArr.count;
    CGFloat btnW = self.xqq_width / buttonCount;
    CGFloat btnH = self.xqq_height;
    for (NSInteger i = 0; i < buttonCount; i ++) {
        UIButton * button = self.buttonArr[i];
        button.xqq_y = 0;
        button.xqq_x = i * btnW;
        button.xqq_width = btnW;
        button.xqq_height = btnH;
    }
    //设置分割线的frame
    NSInteger divierCount = self.dividerArr.count;
    for (NSInteger i = 0; i < divierCount; i ++) {
        UIImageView * divier = self.dividerArr[i];
        divier.xqq_width = 1;
        divier.xqq_height = btnH;
        divier.xqq_x = (i + 1) * btnW;
        divier.xqq_y = 0;
    }
    
}
- (void)setUpButtonCount:(NSInteger)count
                  button:(UIButton*)button
                   title:(NSString*)title{
    if (count) {//数字不为0
        if (count < 1000) {//不足1000直接显示数字
            title = [NSString stringWithFormat:@"%ld",count];
        }else{//达到一万以上 显示11.1W 不能有.0
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万",wan];
            //将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)setEssenceModel:(XQQEssenceModel *)essenceModel{
    _essenceModel = essenceModel;
    [self setUpButton:self.supportBtn number:essenceModel.ding placeHolder:@"顶"];
    [self setUpButton:self.stampBtn number:essenceModel.hate placeHolder:@"踩"];
    [self setUpButton:self.repeatBtn number:essenceModel.repost placeHolder:@"分享"];
    [self setUpButton:self.commentBtn number:essenceModel.comment placeHolder:@"评论"];
}

- (void)setUpButton:(UIButton*)button
             number:(NSInteger)number
        placeHolder:(NSString*)placeHolder{
    if (number >= 10000) {//大于1W
        [button setTitle:[NSString stringWithFormat:@"%.1f万",number / 10000.0] forState:UIControlStateNormal];
    }else if (number > 0){
        [button setTitle:[NSString stringWithFormat:@"%ld",number] forState:UIControlStateNormal];
    }else{
        [button setTitle:placeHolder forState:UIControlStateNormal];
    }
}


+ (instancetype)toolbar{
    return [[self alloc]init];
}



/**创建按钮*/
- (UIButton*)setUpButtonWithTitle:(NSString*)title icon:(NSString*)icon hlightImage:(NSString*)hlightImage tag:(NSInteger)tag{
    UIButton * button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hlightImage] forState:UIControlStateHighlighted];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    [button setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.tag = tag;
    [button addTarget:self action:@selector(bottomBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self.buttonArr addObject:button];
    return button;
}


- (NSMutableArray *)dividerArr{
    if (!_dividerArr) {
        _dividerArr = @[].mutableCopy;
    }
    return _dividerArr;
}
- (NSMutableArray *)buttonArr{
    if (!_buttonArr) {
        _buttonArr = @[].mutableCopy;
    }
    return _buttonArr;
}
/**按钮点击事件*/
- (void)bottomBtnDidPress:(UIButton*)button{
    _bottomButtonDidPress(button.tag);
}

@end
