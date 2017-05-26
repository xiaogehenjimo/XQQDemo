//
//  XQQAddressViewController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQAddressViewController.h"
#import "XQQAddFriendController.h"
#import "XQQAddressCell.h"
#import "XQQFriendDetailController.h"
#import "XQQFriendModel.h"
@interface XQQAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
/*列表*/
@property(nonatomic, strong)  UITableView * addressTableView;
/** 数据 */
@property(nonatomic, strong)  NSMutableArray  *  addDataArr;


@end

@implementation XQQAddressViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //注册监听 监听获取到好友信息成功
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetFriendInfo:) name:XQQNoticFriendList object:nil];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
///*拉取到bmob好友信息会走这个方法*/
//- (void)didGetFriendInfo:(NSNotification*)notice{
//    /*存储了好友信息 BmobObject类型*/
//    NSArray * infoArr = (NSArray*)notice.object;
//    if (infoArr.count > 0) {
//        [self.addDataArr removeAllObjects];
//        for (BmobObject * obj in infoArr) {
//            //取值
//            NSString * nickName = [obj objectForKey:@"nickName"];
//            NSString * userName = [obj objectForKey:@"userName"];
//            NSString * iconURL = [obj objectForKey:@"iconURL"];
//            
//            NSNumber * number = [obj objectForKey:@"isOnline"];
//            BOOL isOnline = number.boolValue;
//
//            XQQFriendModel * model = [[XQQFriendModel alloc]init];
//            model.nickName = nickName;
//            model.userName = userName;
//            model.iconImgaeURL = iconURL;
//            model.isOnline = isOnline;
//            //更新数据库好友信息
//            [[XQQDataManager sharedDataManager] updateFriendInfo:model];
//            [self.addDataArr addObject:model];
//        }
//        [self refresh];
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //判断网络状态
    if ([[[XQQManager sharedManager] getNetStates] isEqualToString:@"无网络"]) {
        //加载数据库好友 数组存的是XQQFriendModel
        NSArray * allFriend = [[XQQDataManager sharedDataManager] searchAllFriend];
        [self.addDataArr removeAllObjects];
        if (allFriend.count > 0) {
            [self.addDataArr setArray:allFriend];
            [self refresh];
        }else{
            [self.view showToastWithStr:@"没有好友,快去添加好友吧!"];
        }
    }else{
        //获取服务器好友列表
        [self getFriendList];
    }
}

/*获取好友列表*/
- (void)getFriendList{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (buddyList.count) {//有值
            [self.addDataArr removeAllObjects];
            //存储好友名字的数组
            NSMutableArray * friendNameArr = @[].mutableCopy;
            for (EMBuddy * buddy in buddyList) {
                [friendNameArr addObject:buddy.username];
                XQQFriendModel * model = [[XQQFriendModel alloc]init];
                model.userName = buddy.username;
                model.iconImgaeURL = @"1.jpg";
                model.isOnline = NO;
                model.nickName = @"暂未设置";
                //插入一个好友到数据库
                [[XQQDataManager sharedDataManager] insertNewFriendWithBody:model];
                [self.addDataArr addObject:model];
            }
            //去bmob拉去好友信息
//            [[XQQUserInfoTool sharedManager] getfriendPersionInfo:friendNameArr];
            [[XQQUserInfoTool sharedManager] getFriendPersionInfo:friendNameArr complete:^(NSArray *array, NSError *error) {
                /*存储了好友信息 BmobObject类型*/
                NSArray * infoArr = array;
                if (infoArr.count > 0) {
                    [self.addDataArr removeAllObjects];
                    for (BmobObject * obj in infoArr) {
                        //取值
                        NSString * nickName = [obj objectForKey:@"nickName"];
                        NSString * userName = [obj objectForKey:@"userName"];
                        NSString * iconURL = [obj objectForKey:@"iconURL"];
                        NSNumber * number = [obj objectForKey:@"isOnline"];
                        BOOL isOnline = number.boolValue;
                        XQQFriendModel * model = [[XQQFriendModel alloc]init];
                        model.nickName = nickName;
                        model.userName = userName;
                        model.iconImgaeURL = iconURL;
                        model.isOnline = isOnline;
                        //更新数据库好友信息
                        [[XQQDataManager sharedDataManager] updateFriendInfo:model];
                        [self.addDataArr addObject:model];
                    }
                    [self refresh];
                }
            }];
        }else{
          [self.view showToastWithStr:@"没有好友,快去添加好友吧!"];
            [self.addressTableView.mj_header endRefreshing];
        }
    } onQueue:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addDataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQAddressCell * cell = [XQQAddressCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.addDataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //跳到好友详情界面
    XQQFriendDetailController * detailVC = [[XQQFriendDetailController alloc]init];
    detailVC.buddy = self.addDataArr[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - activity
/*刷新方法*/
- (void)refresh{
    [self.addressTableView reloadData];
    if ([self.addressTableView.mj_header isRefreshing]) {
        [self.addressTableView.mj_header endRefreshing];
    }
}
/*添加好友按钮点击*/
- (void)addFriendBtnPress:(UIBarButtonItem*)item{
    XQQAddFriendController * addVC = [[XQQAddFriendController alloc]init];
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - setter&getter

- (void)createUI{
  //右侧添加好友按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendBtnPress:)];
    [self.view addSubview:self.addressTableView];

}
- (UITableView *)addressTableView{
    if (!_addressTableView) {
        _addressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight-49) style:UITableViewStylePlain];
        _addressTableView.delegate = self;
        _addressTableView.dataSource = self;
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFriendList)];
        _addressTableView.mj_header = header;
    }
    return _addressTableView;
}

- (NSMutableArray *)addDataArr{
    if (!_addDataArr) {
        _addDataArr = @[].mutableCopy;
    }
    return _addDataArr;
}



@end
