//
//  XQQFaceView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQFaceView.h"
#import "XQQFaceModel.h"
#import "XQQFaceSmallView.h"
#import "XQQFaceBigView.h"


#define sendFaceBtnWidth  70 //发送表情按钮的宽

@interface XQQFaceView ()<UIScrollViewDelegate>
/*下方的类型数组*/
@property(nonatomic, strong)  NSArray  *  typeArr;
/*pageControl*/
@property(nonatomic, strong)  UIPageControl  *  pageControl;
/*装滚动视图的数组*/
@property(nonatomic, strong)  NSMutableArray  *  faceScrollView;
/*表情数组*/
@property(nonatomic, strong)  NSArray * faceArr;
/*当前scrollview的位置*/
@property(nonatomic, assign)  NSInteger   currentScrPage;
/*当前页数*/
@property(nonatomic, assign)  NSUInteger   currentPage;
/*总页数*/
@property(nonatomic, assign)  NSUInteger   allPage;
@end

@implementation XQQFaceView
{
    BOOL _isBottomButtonClicked;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor yellowColor];
        //创建下方的scrollView
        [self createBottomScrollView];
        //初始化上部的scrollView
        [self createTopScrollView];
        //创建pageControl
        [self createPageControl];
    }
    return self;
}

/*创建pageControl*/
- (void)createPageControl{
    CGFloat pageControlX = iphoneWidth/2 - 70;
    CGFloat pageControlY = self.bottomScrollView.frame.origin.y - 20;
    CGFloat pageControlW = 140;
    CGFloat pageControlH = 20;
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
    self.pageControl.numberOfPages = [self pageOfFaceArr:_faceArr.firstObject];//以后换成表情的页数
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
}

/*返回页数*/
- (NSInteger)pageOfFaceArr:(NSArray*)arr{
    return ([arr count] - 1)/30 + 1;
}

/*初始化上部的scrollView*/
- (void)createTopScrollView{
    CGFloat topBigScrollViewX = 0;
    CGFloat topBigScrollViewY = 0;
    CGFloat topBigScrollViewW = iphoneWidth;
    CGFloat topBigScrollViewH = self.frame.size.height - self.bottomScrollView.frame.size.height;
    self.topBigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(topBigScrollViewX, topBigScrollViewY, topBigScrollViewW, topBigScrollViewH)];
    self.topBigScrollView.delegate = self;
    //self.topBigScrollView.bounces = NO;
    //加载表情
    //默认表情
    NSArray * defaultModelArr = [XQQFaceModel mj_objectArrayWithFilename:@"defaultInfo.plist"];
    
    //浪小花
    NSArray * lxhModelArr = [XQQFaceModel mj_objectArrayWithFilename:@"lxhInfo.plist"];
    //emoji
    //emojiInfo
    NSArray * emojiModelArr = [XQQFaceModel mj_objectArrayWithFilename:@"emojiInfo.plist"];
    
    //emotion3
    //panda
    NSArray * pandaModelArr = [XQQFaceModel mj_objectArrayWithFilename:@"emotion3.plist"];

    _faceArr = @[defaultModelArr,lxhModelArr,emojiModelArr,pandaModelArr];
    for (NSInteger i = 0; i < _faceArr.count; i ++) {
        CGFloat viewW = iphoneWidth;
        CGFloat viewX = i * iphoneWidth;
        CGFloat viewY = 0;
        CGFloat viewH = self.frame.size.height - self.bottomScrollView.frame.size.height;
        XQQFaceBigView * view = [[XQQFaceBigView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        view.faceArr = _faceArr[i];
        view.pageControlBlock = ^(NSInteger pageCount,NSInteger currentPage){
            _allPage = pageCount;
            _currentPage = currentPage;
            _pageControl.currentPage = currentPage;
        };
        [self.topBigScrollView addSubview:view];
    }
    self.topBigScrollView.contentSize = CGSizeMake(iphoneWidth * _typeArr.count, 0);
    self.topBigScrollView.showsVerticalScrollIndicator = NO;
    self.topBigScrollView.showsHorizontalScrollIndicator = NO;
    self.topBigScrollView.pagingEnabled = YES;
    [self addSubview:self.topBigScrollView];
}

/*创建下方的scrollView*/
- (void)createBottomScrollView{
    
    CGFloat bottomScrollViewX = 0;
    CGFloat bottomScrollViewY = self.frame.size.height - 30;
    CGFloat bottomScrollViewW = iphoneWidth - sendFaceBtnWidth;
    CGFloat bottomScrollViewH = 30;
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(bottomScrollViewX, bottomScrollViewY, bottomScrollViewW, bottomScrollViewH)];
    //创建发送按钮
    UIButton * sendFaceBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bottomScrollView.xqq_right, bottomScrollViewY, sendFaceBtnWidth, bottomScrollViewH)];
    
    [sendFaceBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    [sendFaceBtn setTitleColor:XQQColor(84, 167, 54) forState:UIControlStateNormal];
    
    sendFaceBtn.backgroundColor = XQQSingleColor(242);
    
    [sendFaceBtn addTarget:self action:@selector(sendFaceBtnDidPress) forControlEvents:UIControlEventTouchUpInside];
    
    /*创建按钮*/
    NSArray * nameArr = @[@"默认",@"浪小花",@"emoji",@"熊猫"];
    _typeArr = nameArr;
    for (NSInteger i = 0; i < nameArr.count; i ++) {
        CGFloat faceTypeBtnW = bottomScrollViewW / 4;
        CGFloat faceTypeBtnX = i * faceTypeBtnW;
        CGFloat faceTypeBtnY = 0;
        CGFloat faceTypeBtnH = 30;
        UIButton * faceTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(faceTypeBtnX, faceTypeBtnY, faceTypeBtnW, faceTypeBtnH)];
        faceTypeBtn.layer.borderWidth = 1;
        faceTypeBtn.layer.borderColor = [UIColor grayColor].CGColor;
        if (i == 0) {
            faceTypeBtn.backgroundColor = [UIColor grayColor];
        }else{
            faceTypeBtn.backgroundColor = [UIColor whiteColor];
        }
        [faceTypeBtn setTitle:nameArr[i] forState:UIControlStateNormal];
        [faceTypeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        faceTypeBtn.tag = 886 + i;
        [faceTypeBtn addTarget:self action:@selector(faceTypeBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomScrollView addSubview:faceTypeBtn];
    }
    self.bottomScrollView.contentSize = CGSizeMake(nameArr.count * bottomScrollViewW/4, 0);
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.bottomScrollView];
    [self addSubview:sendFaceBtn];
}

#pragma mark - activity

/** 下方发送表情按钮点击 */
- (void)sendFaceBtnDidPress{
    if (self.sendFaceBtnPressBlock) {
        self.sendFaceBtnPressBlock();
    }
}

/*下方类型的按钮点击*/
- (void)faceTypeBtnDidPress:(UIButton*)button{
    //_currentScrPage =
    NSArray * subViews = self.bottomScrollView.subviews;
    for (UIButton * button in subViews) {
        button.backgroundColor = [UIColor whiteColor];
    }
    button.backgroundColor = [UIColor grayColor];
    [self changePage:button.tag - 886];
    _currentScrPage = button.tag - 886;
    _bottomFaceTypeBtnPress(button.tag - 886);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //判断偏移量
    if(scrollView == self.topBigScrollView){
        NSUInteger facePageCount = (NSUInteger)(self.topBigScrollView.contentOffset.x / self.topBigScrollView.xqq_width);
        CGFloat currentScrX = _currentScrPage * scrollView.xqq_width;
        if (currentScrX > scrollView.contentOffset.x) {
            if (_currentScrPage - 1 < 0 ) {
                return;
            }
            XQQFaceBigView *emotionLi =scrollView.subviews[_currentScrPage - 1];
            emotionLi.scrollView.contentOffset = CGPointMake((emotionLi.pageNum - 1)*iphoneWidth, 0);
        }else if (currentScrX < scrollView.contentOffset.x){
            if ((_currentScrPage + 1) > scrollView.subviews.count -1) {
                return;
            }
            XQQFaceBigView *emotionLi =scrollView.subviews[_currentScrPage + 1];
            emotionLi.scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (_isBottomButtonClicked) {
            XQQFaceBigView *faceView = self.topBigScrollView.subviews[facePageCount];
            faceView.scrollView.contentOffset = CGPointMake(0, 0);
            _pageControl.numberOfPages = faceView.pageNum;
            _pageControl.currentPage = 0;
            _isBottomButtonClicked = NO;
            return;
        }
        NSUInteger count = (NSUInteger)(scrollView.contentOffset.x / scrollView.xqq_width + 0.5);
        if (count > self.topBigScrollView.subviews.count - 1) return;
        XQQFaceBigView *emotionListView = self.topBigScrollView.subviews[count];
        //总页数
        _pageControl.numberOfPages =  emotionListView.pageNum;
        
        
        if (_currentScrPage > count) {
            _pageControl.currentPage = emotionListView.pageNum -1 ;
            emotionListView.scrollView.contentOffset = CGPointMake((emotionListView.pageNum - 1) * iphoneWidth, 0);
        }else if (_currentScrPage < count){
            _pageControl.currentPage = 0;
            emotionListView.scrollView.contentOffset = CGPointMake(0, 0);
        }
        _currentScrPage = count;
        CGPoint offset = scrollView.contentOffset;
        NSArray * buttonArr = self.bottomScrollView.subviews;
        //计算当前的页码
        NSInteger currentIndex = (offset.x / iphoneWidth + .5);
        _currentScrPage = currentIndex;
        //NSLog(@"%ld",currentIndex);
        [UIView animateWithDuration:.5f animations:^{
            for (NSInteger i = 0; i < buttonArr.count; i ++) {
                if (i == currentIndex) {
                    UIButton * button = buttonArr[currentIndex];
                    button.backgroundColor = [UIColor grayColor];
                }else{
                    UIButton * button = buttonArr[i];
                    button.backgroundColor = [UIColor whiteColor];
                }
            }
            if (currentIndex > 3) {
                self.bottomScrollView.contentOffset = CGPointMake((iphoneWidth - sendFaceBtnWidth)/4 *(currentIndex - 3), 0);
            }else if(currentIndex < 1){
                self.bottomScrollView.contentOffset = CGPointMake(0, 0);
            }
        }];
    }
}

/*修改scrollView偏移量*/
- (void)changePage:(NSInteger)button{
    _isBottomButtonClicked = YES;
    self.topBigScrollView.contentOffset = CGPointMake(button * iphoneWidth, 0);
}
- (NSMutableArray *)faceScrollView{
    if (!_faceScrollView) {
        _faceScrollView = @[].mutableCopy;
    }
    return _faceScrollView;
}




@end
