//
//  XQQSearchTopVIew.m
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/12.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQSearchTopVIew.h"
#import "XQQCollectionViewCell.h"

@interface XQQSearchTopVIew ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,collectionItemPressDelegate>

@property(nonatomic, strong)  UICollectionView  *  collectionView;
/** 数据源 */
@property(nonatomic, strong)  NSMutableArray  *  dataArr;

/** 高度 */
@property(nonatomic, assign)  CGFloat   collectionHeight;

/** frame */
@property(nonatomic, assign)  CGRect   selfFrame;

@end

@implementation XQQSearchTopVIew

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.selfFrame = frame;
        [self.dataArr setArray:@[@{@"icon":@"icon_classify_takeout",@"title":@"美食"},@{@"icon":@"icon_classify_hotel",@"title":@"酒店"},@{@"icon":@"icon_classify_bus",@"title":@"公交站"},@{@"icon":@"icon_classify_bank",@"title":@"银行"},@{@"icon":@"icon_classify_scenic",@"title":@"景点"},@{@"icon":@"icon_classify_cinema",@"title":@"电影院"},@{@"icon":@"icon_classify_ktv",@"title":@"KTV"},@{@"icon":@"icon_classify_mall",@"title":@"商店"}]];
        [self addSubview:self.collectionView];
        
        [self layoutIfNeeded];
        //self.xqq_bottom = self.collectionView.xqq_bottom;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.xqq_height = _collectionHeight;
    self.collectionView.xqq_height = _collectionHeight;
}


#pragma mark - collectionItemPressDelegate

- (void)collectionItemDidPress:(NSInteger)index
                      dataDict:(NSDictionary *)dataDict
                          item:(XQQCollectionViewCell *)item{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xqq_searchTopViewItemPress:index:dataDict:)]) {
        [self.delegate xqq_searchTopViewItemPress:item index:index dataDict:dataDict];
    }
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"GradientCell";
    XQQCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.dataDict = self.dataArr[indexPath.row];
    return cell;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置每个item的大小
        CGFloat widths = (iphoneWidth - (45 + 24 * 3))/4.0;
        
        CGFloat itemHeight = widths + 10 + 20;
        layout.itemSize = CGSizeMake(widths, itemHeight);
        //计算collectionView的高度 2行
        _collectionHeight = 15 + 18 + 15 + itemHeight * 2;
        
        // 设置最小行间距
        layout.minimumLineSpacing = 14;
        // 设置垂直间距
        //layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(15, 22.5, 18, 22.5);
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //这个时候 是没有frame的  外面用masonry  这个类也得用masonry
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.selfFrame.size.width, self.selfFrame.size.height) collectionViewLayout:layout];
        [self.collectionView registerClass:[XQQCollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

@end
