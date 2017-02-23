//
//  XQQSearchBottomTableView.m
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/13.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQSearchBottomTableView.h"


@interface XQQSearchBottomTableView ()<UITableViewDelegate,UITableViewDataSource>

/** 表格视图 */
@property(nonatomic, strong) UITableView * myTableView;
/** 排名的数组 */
@property(nonatomic, strong)  NSMutableArray  *  tempArr;

@end

@implementation XQQSearchBottomTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUIWithFrame:frame];
    }
    return self;
}

- (void)initUIWithFrame:(CGRect)frame{
    [self addSubview:self.myTableView];
    self.myTableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    //self.myTableView.backgroundColor = [UIColor orangeColor];
}

#pragma mark - UITbaleViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tempArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * infoDict = self.tempArr[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyCellDidPress:)]) {
        [self.delegate historyCellDidPress:infoDict];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"searchCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    NSDictionary * dataDict = self.tempArr[indexPath.row];
    cell.textLabel.text = dataDict[search_name];
    cell.backgroundColor = XQQColor(250, 250, 250);
    return cell;
}


- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    //根据搜索时间进行排序
    [self.tempArr setArray:dataArr];
    NSInteger count = self.tempArr.count;
    
    for (NSInteger i = 0; i < count; i ++ ) {
        for (NSInteger j = 0; j < count - 1 - i; j ++) {
            //取出数据库存储的字典
            NSDictionary * previousModel = self.tempArr[j];
            NSDictionary * nextModel = self.tempArr[j+1];
            NSString * previousDateStr = previousModel[search_time];
            NSString * nextDateStr = nextModel[search_time];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = xqq_timeFormat;
            NSDate * previousDate = [formatter dateFromString:previousDateStr];
            NSDate * nextDate = [formatter dateFromString:nextDateStr];
            //上一个 和下一个进行对比
            NSComparisonResult result = [previousDate compare:nextDate];
            
            if (result == NSOrderedAscending) { // 升序, 越往右边越大
                //大的就是新的
                [self.tempArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            } else if (result == NSOrderedDescending) { // 降序, 越往右边越小
            } else {
                NSLog(@"两个日期相等");
            }
        }
    }
    [self.myTableView reloadData];
}

#pragma mark - setter&&getter

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        //头视图
        UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, 44)];
        headerLabel.backgroundColor = XQQSingleColor(242);
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont boldSystemFontOfSize:17];
        headerLabel.textColor = XQQColor(128, 189, 140);
        headerLabel.text = @"- 历史搜索记录 -";
        _myTableView.tableHeaderView = headerLabel;
    }
    return _myTableView;
}

- (NSMutableArray *)tempArr{
    if (!_tempArr) {
        _tempArr = @[].mutableCopy;
    }
    return _tempArr;
}
@end
