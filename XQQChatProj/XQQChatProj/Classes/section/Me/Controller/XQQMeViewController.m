//
//  XQQMeViewController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQMeViewController.h"
#import "XQQMeModel.h"
#import "XQQMeTableViewCell.h"
#import "XQQMeFirstCell.h"
#import "XQQMeSetViewController.h"
#import "XQQPersionInfoController.h"

@interface XQQMeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**数据源*/
@property(nonatomic, strong)  NSMutableArray * dataArr;
/** 列表 */
@property(nonatomic, strong)  UITableView  *  myTableView;
@end

@implementation XQQMeViewController
/*获取到当前登录的个人信息会走这个方法*/
//- (void)getPersonInfo:(NSNotification*)notic{
//    NSArray * infoArr = (NSArray*)notic.object;
//    BmobObject * ff = infoArr[0];
//    NSMutableArray * tmpArr = @[].mutableCopy;
//    NSString * nickName = [ff objectForKey:@"nickName"];
//    NSString * iconURL = [ff objectForKey:@"iconURL"];
//    XQQMeModel * model = [[XQQMeModel alloc]init];
//    [model setValuesForKeysWithDictionary:@{@"name":nickName,@"image":iconURL}];
//    [tmpArr addObject:model];
//    //更新本地数据库个人信息
//    [[XQQDataManager sharedDataManager] updatePersonTable:@{@"userName":[XQQManager sharedManager].userName,@"imageURL":iconURL,@"nickName":nickName}];
//    [self.dataArr replaceObjectAtIndex:0 withObject:tmpArr];
//    [self.myTableView reloadData];
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[[XQQUserInfoTool sharedManager] getMyInfo];
    
    [[XQQUserInfoTool sharedManager] getMyInfoComplete:^(NSArray *array, NSError *error) {
        BmobObject * ff = array[0];
        NSMutableArray * tmpArr = @[].mutableCopy;
        NSString * nickName = [ff objectForKey:@"nickName"];
        NSString * iconURL = [ff objectForKey:@"iconURL"];
        XQQMeModel * model = [[XQQMeModel alloc]init];
        [model setValuesForKeysWithDictionary:@{@"name":nickName,@"image":iconURL}];
        [tmpArr addObject:model];
        //更新本地数据库个人信息
        [[XQQDataManager sharedDataManager] updatePersonTable:@{@"userName":[XQQManager sharedManager].userName,@"imageURL":iconURL,@"nickName":nickName}];
        [self.dataArr replaceObjectAtIndex:0 withObject:tmpArr];
        [self.myTableView reloadData];
    }];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonInfo:) name:XQQNoticPersonInfo object:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //数据源
    [self.view addSubview:self.myTableView];
    NSArray * tmpArr = @[@[@{@"name":@"",@"image":@"1"}],
                         @[@{@"name":@"设置",@"image":@"MoreSetting"}]];
    
    for (NSArray * infoArr in tmpArr) {
        NSMutableArray * mut = [NSMutableArray array];
        for (NSDictionary * dict in infoArr) {
            XQQMeModel * model = [[XQQMeModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [mut addObject:model];
        }
        [self.dataArr addObject:mut];
    }
    [self.myTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = self.dataArr[section];
    if (section == 0) {
        return 1;
    }else{
        return arr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        XQQMeFirstCell * cell = [XQQMeFirstCell cellForTableView:tableView rowAtIndexPath:indexPath];
        XQQMeModel * model = self.dataArr[0][0];
        cell.persionInfo = model;
        return cell;
    }else{
        XQQMeTableViewCell * cell = [XQQMeTableViewCell cellForTableView:tableView forIndexPath:indexPath];
        XQQMeModel * model = self.dataArr[indexPath.section][indexPath.row];
        cell.infoModel = model;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {//设置
        XQQMeSetViewController * setVC = [[XQQMeSetViewController alloc]init];
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
    }else if (indexPath.section == 0){
        //个人信息点击
        XQQPersionInfoController * persionVC = [[XQQPersionInfoController alloc]init];
        persionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:persionVC animated:YES];
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100.0;
    }else{
      return 50.0;
    }
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight - 49) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}
@end
