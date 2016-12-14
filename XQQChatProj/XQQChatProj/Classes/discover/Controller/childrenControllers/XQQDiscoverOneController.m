//
//  XQQDiscoverOneController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQDiscoverOneController.h"
#import <ZFPlayer.h>
#import "XQQEssenceModel.h"
#import "XQQEssenceFrameModel.h"
#import "XQQEssenceTableViewCell.h"
@interface XQQDiscoverOneController ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
/**tableViewDataSource*/
@property(nonatomic, strong) NSMutableArray * dataArr;
/**tableView*/
@property(nonatomic, strong) UITableView  *  tableView;
/**maxtime*/
@property(nonatomic, copy)   NSString  *  maxtime;
@end

@implementation XQQDiscoverOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = @"1";
    [self initUI];
    //请求数据
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadMoreDataWithMxTime:(NSString*)maxtime
                          type:(NSString*)type{
    [[XQQAPIClient sharedAPIClient] getEssenceListWithMethod:@"GET" maxtime:maxtime type:type success:^(id respondObject) {
        //存储获取的相关info
        //_maxtime = respondObject[@"info"][@"maxtime"];
        
        [[XQQManager sharedManager] updateInfoDict:respondObject[@"info"] key:self.className];
        
        //数组
        NSArray * listArr = respondObject[@"list"];
        //建立model
        for (NSDictionary * obj in listArr) {
            XQQEssenceModel * model = [[XQQEssenceModel alloc]init];
            [model setValuesForKeysWithDictionary:obj];
            XQQEssenceFrameModel * frameModel = [[XQQEssenceFrameModel alloc]init];
            frameModel.essenceModel = model;
            [self.dataArr addObject:frameModel];
        }
        [self refreshTableView];
    } failure:^(NSError *error) {
        XQQLog(@"请求失败了%@",error.description);
    }];
}
/**请求数据*/
- (void)loadRequestWithMaxtime:(NSString*)maxtime
                          type:(NSString*)type{
    [[XQQAPIClient sharedAPIClient] getEssenceListWithMethod:@"GET" maxtime:maxtime type:type success:^(id respondObject) {
        //XQQWriteToPlist(respondObject, @"testPlist");
        //存储获取的相关info
        //        _maxtime = respondObject[@"info"][@"maxtime"];
        XQQManager * manager = [XQQManager sharedManager];
        [manager updateInfoDict:respondObject[@"info"] key:self.className];
        //数组
        NSArray * listArr = respondObject[@"list"];
        // NSLog(@"%@",listArr);
        //建立model
        if (self.dataArr.count > 0) {
            [self.dataArr removeAllObjects];
        }
        for (NSDictionary * obj in listArr) {
            XQQEssenceModel * model = [[XQQEssenceModel alloc]init];
            [model setValuesForKeysWithDictionary:obj];
            XQQEssenceFrameModel * frameModel = [[XQQEssenceFrameModel alloc]init];
            frameModel.essenceModel = model;
            [self.dataArr addObject:frameModel];
        }
        [self refreshTableView];
    } failure:^(NSError *error) {
        XQQLog(@"请求失败了%@",error.description);
    }];
}

- (void)initUI{
    self.view.backgroundColor = XQQRandomColor;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQEssenceTableViewCell* cell =[XQQEssenceTableViewCell cellWithTabelView:tableView WithIndexPath:indexPath];
    cell.cellIndexPath = indexPath;
    cell.tableView = tableView;
    XQQEssenceFrameModel * frameModel = self.dataArr[indexPath.row];
    cell.frameModel = frameModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQEssenceFrameModel * frameModel = self.dataArr[indexPath.row];
    return frameModel.cellHeight;
}
/**cell消失的时候调用*/
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    XQQEssenceTableViewCell * myCell = (XQQEssenceTableViewCell*)cell;
    [myCell removePlayerWithCell:myCell];
}

- (void)refreshTableView{
    if ([_tableView.mj_footer isRefreshing]) {
        [_tableView.mj_footer endRefreshing];
    }
    if ([_tableView.mj_header isRefreshing]) {
        [_tableView.mj_header endRefreshing];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark - setter&getter
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight - 64 - 49 - 40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = [XQQRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadRequestWithMaxtime:@"" type:_type];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreDataWithMxTime:[[XQQManager sharedManager] getMaxtimeWithKey:self.className] type:_type];
        }];
    }
    return _tableView;
}

@end
