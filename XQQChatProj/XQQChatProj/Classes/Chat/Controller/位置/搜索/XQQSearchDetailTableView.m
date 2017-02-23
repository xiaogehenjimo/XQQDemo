//
//  XQQSearchDetailTableView.m
//  XQQPanoramaDemo
//
//  Created by XQQ on 2017/1/16.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQSearchDetailTableView.h"

@interface XQQSearchDetailTableView ()<UITableViewDelegate,UITableViewDataSource>

/*视图*/
@property(nonatomic, strong)  UITableView  *  myTableView;
/** frame */
@property(nonatomic, assign)  CGRect   myFrame;


@end


@implementation XQQSearchDetailTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.myFrame = frame;
        [self addSubview:self.myTableView];
        
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    
    
    [self.myTableView reloadData];
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"detailCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor lightGrayColor];
    BMKPoiInfo * model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchDetailTableViewDidPress:)]) {
        [self.delegate searchDetailTableViewDidPress:self.dataArr[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

#pragma mark - setter&getter

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.myFrame.size.width, self.myFrame.size.height) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}
@end
