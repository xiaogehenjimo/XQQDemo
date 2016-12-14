//
//  XQQScrollMenuView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQScrollMenuView.h"

#define backGroundColor     [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.f]
#define defaultLabelColor   [UIColor blackColor]
#define defaultBottomColor  [UIColor clearColor]
#define btnSelectedColor [UIColor redColor]
#define iphoneWidth  [UIScreen mainScreen].bounds.size.width
#define iphoneHeight [UIScreen mainScreen].bounds.size.height
#define labelMargin  15

@interface XQQScrollMenuView ()<scrollBtnDidPress,UIScrollViewDelegate>

@end

@implementation XQQScrollMenuView
/**初始化*/
+ (instancetype)createTopScrollViewWithFrame:(CGRect)frame{
    return [[self alloc]initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = self;
    }
    return self;
}
/**设置数组*/
- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    //创建小按钮
    CGFloat scrollBtnY = 0;
    CGFloat scrollBtnH = self.frame.size.height;
    for (NSInteger i = 0; i < titleArr.count; i ++) {
        // 计算文字尺寸  (可用于文字数量过多)
        //        CGSize btnSize = [self sizeWithText:titleArr[i] font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height * .9)];
        // 计算内容的宽度
        CGFloat btnW = 70;
        //创建按钮
        CGFloat scrollBtnX = i * (btnW + .5);
        XQQScrollBtn * button = [[XQQScrollBtn alloc]initWithFrame:CGRectMake(scrollBtnX, scrollBtnY, btnW, scrollBtnH)];
        button.delegate = self;
        [button setTitle:titleArr[i]];
        if (i == 0) {
            [button setTitleColor:btnSelectedColor];
            [button setBottomColor:btnSelectedColor];
        }
        [self addSubview:button];
        //添加到按钮数组中
        [self.btnArr addObject:button];
    }
    //设置contentSize
    //取出最后一个控件
    XQQScrollBtn * lastObject = self.subviews.lastObject;
    self.contentSize = CGSizeMake(CGRectGetMaxX(lastObject.frame),self.frame.size.height);
}

/**重写set方法 判断顶部滚动视图的偏移量*/
- (void)setIndex:(NSInteger)index{
    _index = index;
    /**滚动顶部的滚动视图*/
    [self scrollTopScrollViewWithIndex:index];
}

/**滚动顶部的滚动视图*/
- (void)scrollTopScrollViewWithIndex:(NSInteger)index{
    //取出当前按钮
    XQQScrollBtn * currentBtn = self.btnArr[index];
    //判断当前页是否在中间
    // 计算偏移量
    CGFloat offsetX = currentBtn.center.x - iphoneWidth * 0.5;
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.contentSize.width - iphoneWidth;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
/**添加控制器*/
- (NSArray*)addChildrenControllersWithArr:(NSArray*)controllers AndSuperController:(id)superController{
    NSMutableArray * controllersArr = @[].mutableCopy;
    for (NSString * controllerName in controllers) {
        Class controllerClass = NSClassFromString(controllerName);
        [controllersArr addObject:[[controllerClass alloc]init]];
        [superController addChildViewController:[[controllerClass alloc]init]];
    }
    _controllers = controllersArr;
    return controllersArr;
}
/**返回子视图控制器 !必须添加完控制器才能获取到*/
- (NSArray*)GetchildrenControllers{
    return _controllers;
}
/**添加子视图*/
#warning  - 这个方法 会把所有的控制器都初始化
- (void)addSubViewToScrollView:(UIScrollView*)scrollView controllerArr:(NSArray*)controllersArr{
    NSInteger count = controllersArr.count;
    for (NSInteger i = 0; i < count; i ++) {
        UIViewController * controller = controllersArr[i];
        UIView * view = controller.view;//会初始化每个View
        //UIView * view = [[UIView alloc]init];
        CGRect viewFrame = view.frame;
        viewFrame.origin.y = 0;
        viewFrame.origin.x = i * iphoneWidth;
        view.frame = viewFrame;
        [scrollView addSubview:view];
    }
    scrollView.contentSize = CGSizeMake(count * iphoneWidth, scrollView.frame.size.height);
}
/**根据下标添加控制器的View*/
- (void)addSubViewToScrollViewWithIndex:(NSInteger)index superView:(UIScrollView*)superView{
    //如果添加过这个View  return
    if ([superView viewWithTag:index + 1836383]) {
        return;
    }
    UIViewController * controller = _controllers[index];
    UIView * controllView = controller.view;
    controllView.tag = index + 1836383;
    //NSLog(@"添加了的View是:%@",controllView);
    CGRect viewFrame = controllView.frame;
    viewFrame.origin.y = 0;
    viewFrame.origin.x = index * iphoneWidth;
    controllView.frame = viewFrame;
    [superView addSubview:controllView];
    superView.contentSize = CGSizeMake(_controllers.count * iphoneWidth, superView.frame.size.height);
}
/**按钮点击*/
- (void)scrollBtnDidPress:(XQQScrollBtn*)selButton{
    //获取按钮点击的下标
    NSInteger btnIndex = [self.btnArr indexOfObject:selButton];
    /**滚动顶部的滚动视图*/
    [self scrollTopScrollViewWithIndex:btnIndex];
    //改变顶部按钮的文字颜色背景
    [self changeBtnStatesWithBtnIndex:btnIndex];
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollMenuDidPressBtn: index:)]) {
        [self.scrollDelegate scrollMenuDidPressBtn:selButton index:btnIndex];
    }
}
/**设置按钮是否为选中状态*/
- (void)changeBtnStatesWithBtnIndex:(NSInteger)index{
    //找到下标的按钮
    XQQScrollBtn * chagerButton = self.btnArr[index];
    for (XQQScrollBtn * button in self.subviews) {
        if (button == chagerButton) {
            [UIView animateWithDuration:.2f animations:^{//选中
                [button setTitleColor:btnSelectedColor];
                [button setBottomColor:btnSelectedColor];
            }];
        }else{
            [UIView animateWithDuration:.2f animations:^{//非选中
                [button setTitleColor:[UIColor blackColor]];
                [button setBottomColor:backGroundColor];
            }];
        }
    }
}
/**改变控制器中滚动视图的偏移量*/
- (void)changeScrollViewContentOffsetWithIndex:(NSInteger)index scrollView:(UIScrollView*)scrollView{
    [scrollView setContentOffset:CGPointMake(index * iphoneWidth, 0) animated:YES];
}

#pragma mark - setter&getter
/**懒加载按钮数组*/
- (NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = @[].mutableCopy;
    }
    return _btnArr;
}
/**
 *  计算文字尺寸
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
