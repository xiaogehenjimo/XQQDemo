//
//  XQQFaceBigView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQFaceBigView.h"
#import "XQQAllFaceView.h"
@interface XQQFaceBigView ()<UIScrollViewDelegate>
@property(nonatomic, assign)  CGRect   selfFrame;
@end
@implementation XQQFaceBigView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _selfFrame = frame;
    }
    return self;
}
- (NSInteger)pageNum{
    return (_faceArr.count - 1) / 21 + 1;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pageCount = (_faceArr.count - 1) / 21 + 1;
    CGPoint offset = scrollView.contentOffset;
    NSInteger currentIndex = (offset.x / iphoneWidth + .5);
    _pageControlBlock(pageCount,currentIndex);
}

- (void)setFaceArr:(NSArray *)faceArr{
    _faceArr = faceArr;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _selfFrame.size.width, _selfFrame.size.height)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    NSInteger pageCount = (faceArr.count - 1) / 20 + 1;
    //拆分数组
    NSArray * allSubArr = [self splitArray:faceArr withSubSize:20];
    //allFaceView
    for (NSInteger i = 0; i < pageCount; i ++) {
        CGFloat viewX = i * iphoneWidth;
        CGFloat viewY = 0;
        CGFloat viewW = iphoneWidth;
        CGFloat viewH = _selfFrame.size.height;
        XQQAllFaceView * view = [[XQQAllFaceView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        view.detailFaceArr = allSubArr[i];
        [_scrollView addSubview:view];
    }
    self.scrollView.contentSize = CGSizeMake(pageCount * iphoneWidth, 0);
}
/**
 *  拆分数组
 *  @param array   需要拆分的数组
 *  @param subSize 指定长度
 *  @return 包含子数组的数组
 */
- (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    return [arr copy];
}


@end
