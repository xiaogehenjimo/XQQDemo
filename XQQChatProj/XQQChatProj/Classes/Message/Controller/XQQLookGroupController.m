//
//  XQQLookGroupController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/6.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQLookGroupController.h"
#import "XQQLookGroupCell.h"
#import "XQQNavigationController.h"
#import "MainViewController.h"
@interface XQQLookGroupController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
/**数据源*/
@property(nonatomic, strong)  NSMutableArray *  dataArr;
/** 列表 */
@property(nonatomic, strong)  UITableView    *  chatTableView;

@end

@implementation XQQLookGroupController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[[XQQManager sharedManager] getNetStates] isEqualToString:@"无网络"]) {
        //加载本地
        NSArray * groupList = [[EaseMob sharedInstance].chatManager groupList];
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:groupList];
        [self refreshTableView];
        
    }else{//加载网络
        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
            if (groups.count > 0) {
                [self.dataArr removeAllObjects];
                [self.dataArr addObjectsFromArray:groups];
                [self refreshTableView];
            }
        } onQueue:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self getGroupList];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQLookGroupCell * cell = [XQQLookGroupCell cellForTableView:tableView indexPath:indexPath];
    cell.group = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMGroup * group = self.dataArr[indexPath.row];
    XQQChatViewController * chatVC = [[XQQChatViewController alloc]init];
    chatVC.chatGroup = group;
    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.isGroup = YES;
    chatVC.messageType = eMessageTypeGroupChat;
    chatVC.chatConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:group.groupId conversationType:eConversationTypeGroupChat];
    MainViewController * mainVC = (MainViewController*)[[[UIApplication sharedApplication].delegate window] rootViewController];
    mainVC.selectedIndex = 0;
    //消息页面
    XQQNavigationController * messageVC = mainVC.selectedViewController;
    [self.navigationController popViewControllerAnimated:YES];
    _dissmissVC();
    [messageVC pushViewController:chatVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - activity
/*刷新表格*/
- (void)refreshTableView{
    [self.chatTableView reloadData];
    if ([_chatTableView.mj_header isRefreshing]) {
        [_chatTableView.mj_header endRefreshing];
    }
}
/*获取群聊列表*/
- (void)getGroupList{
//    NSArray * groupList = [[EaseMob sharedInstance].chatManager groupList];
    // 从服务端获取群列表
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        if (groups.count > 0) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:groups];
            [self refreshTableView];
        }
    } onQueue:nil];
//    if (groupList.count == 0) {
//        // 从服务端获取群列表
//        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
//            if (groups.count > 0) {
//                [self.dataArr removeAllObjects];
//                [self.dataArr addObjectsFromArray:groups];
//                [self.chatTableView reloadData];
//            }
//        } onQueue:nil];
//    }else{
//        [self.dataArr addObjectsFromArray:groupList];
//        [self.chatTableView reloadData];
//    }
}

#pragma mark - setter&getter

- (void)initUI{
    self.navigationItem.title = @"我的群";
    [self.view addSubview:self.chatTableView];
    
    
    
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

- (UITableView *)chatTableView{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight) style:UITableViewStylePlain];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _chatTableView.mj_header = [XQQRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getGroupList)];
    }
    return _chatTableView;
}
@end
