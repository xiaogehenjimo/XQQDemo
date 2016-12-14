//
//  XQQMessageViewController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/16.
//  Copyright © 2016年 UIP. All rights reserved.
//
#import "XQQMessageViewController.h"
#import "XQQConversationModel.h"
#import "XQQConversationCell.h"
#import "XQQChatViewController.h"
#import "XQQFriendModel.h"
#import "YCXMenu.h"
#import "YCXMenuItem.h"
#import "XQQAddFriendController.h"
#import "XQQAddGroupController.h"
#import "XQQNavigationController.h"
@interface XQQMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
/**会话的列表数据源*/
@property(nonatomic, strong)  NSMutableArray *  dataArr;
/** 列表 */
@property(nonatomic, strong)  UITableView    *  chatTableView;

@end

@implementation XQQMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getConversationList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageDidRecieveMessage:) name:XQQNoticDidRecieveMessage object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //右上角群聊的按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroupBtnDidPress)];
    [self.view addSubview:self.chatTableView];
    /*获取会话列表*/
    [self getConversationList];
    /*判断是否是推送过来的消息*/
    [self ifPush];
}
/*判断是否是推送过来的消息*/
- (void)ifPush{
    //判断是否是推送
    if ([XQQManager sharedManager].isPush) {
        NSDictionary * userInfo = [XQQManager sharedManager].pushDict;
        //NSDictionary * apsDict = userInfo[@"aps"];
        NSString * from = userInfo[@"f"];
        //        NSString * to = userInfo[@"t"];
        //        NSString * message = userInfo[@"m"];
        //        NSInteger badge = (NSInteger)apsDict[@"badge"];
        NSString * groupStr = @"";
        if ([[userInfo allKeys] containsObject:@"g"]) {
            //群聊
            groupStr = userInfo[@"g"];
        }
        //进行跳转
        XQQChatViewController * chatVC = [[XQQChatViewController alloc]init];
        chatVC.hidesBottomBarWhenPushed = YES;
        
        if (![groupStr isEqualToString:@""]) {//群聊
            EMGroup * group = [EMGroup groupWithId:groupStr];
            chatVC.isGroup = YES;
            chatVC.messageType = eMessageTypeGroupChat;
            chatVC.chatConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:groupStr conversationType:eConversationTypeGroupChat];
            chatVC.chatGroup = group;
        }else{//单聊
            XQQFriendModel * friendModel = [[XQQFriendModel alloc]init];
            NSDictionary * friendDict = [[XQQDataManager sharedDataManager] searchFriend:from];
            chatVC.model = friendModel;
            friendModel.userName = from;
            friendModel.nickName = friendDict[@"nickName"];
            friendModel.iconImgaeURL = friendDict[@"iconImageURL"];
            friendModel.isOnline = NO;
            chatVC.isGroup = NO;
            chatVC.messageType = eConversationTypeChat;
            chatVC.chatConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:from conversationType:eConversationTypeChat];
        }
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

/**获取会话列表*/
- (void)getConversationList{
    /*获取会话列表*/
    NSArray * conversationArr = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    if (!conversationArr.count) {
        [self.view showToastWithStr:@"暂时没有会话"];
        [self refreshTableView];
    }else{
        [self.dataArr removeAllObjects];
        for (EMConversation * conversation in conversationArr) {
            XQQConversationModel * model = [[XQQConversationModel alloc]init];
            model.chatConversation = conversation;
            //数据库查找好友信息
            NSDictionary * friendDict = [[XQQDataManager sharedDataManager] searchFriend:conversation.chatter];
            if (friendDict[@"nickName"]) {
                model.nickName = friendDict[@"nickName"];
                model.iconURL = friendDict[@"iconURL"];
                if ([friendDict[@"isOnline"] isEqualToString:@"1"]) {
                    model.isOnline = YES;
                }else{
                    model.isOnline = NO;
                }
            }
            model.chatter = conversation.chatter;
            [self.dataArr addObject:model];
        }
        [self refreshTableView];
    }
}

#pragma mark - activity
/*群聊点击*/
- (void)itemDidPress{
    XQQAddGroupController * groupVC = [[XQQAddGroupController alloc]init];
    groupVC.hidesBottomBarWhenPushed = YES;
    XQQNavigationController * groupNav = [[XQQNavigationController alloc]initWithRootViewController:groupVC];
    [self.navigationController presentViewController:groupNav animated:YES completion:nil];
    //[self.navigationController pushViewController:groupVC animated:YES];
}
/*添加好友点击了*/
- (void)addItemDidPress{
    XQQAddFriendController * addVC = [[XQQAddFriendController alloc]init];
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}

/*添加群聊按钮点击*/
- (void)addGroupBtnDidPress{
    if ([YCXMenu isShow]) {
        [YCXMenu dismissMenu];
    }else{
        YCXMenuItem * item = [YCXMenuItem menuItem:@"发起群聊" image:[UIImage imageNamed:@"tabbar_mainframe"] target:self action:@selector(itemDidPress)];
        item.foreColor = [UIColor whiteColor];
        item.titleFont = [UIFont systemFontOfSize:17];
        YCXMenuItem * addItem = [YCXMenuItem menuItem:@"添加朋友" image:[UIImage imageNamed:@"sharemore_friendcard"] target:self action:@selector(addItemDidPress)];
        addItem.titleFont = [UIFont systemFontOfSize:17];
        addItem.foreColor = [UIColor whiteColor];
        
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(iphoneWidth - 60, 0, 60, 60) menuItems:@[item,addItem] selected:^(NSInteger index, YCXMenuItem *item) {
            
        }];
    }
}

/*刷新tableView*/
- (void)refreshTableView{
    [self.chatTableView reloadData];
    if ([_chatTableView.mj_header isRefreshing]) {
        [_chatTableView.mj_header endRefreshing];
    }
}

/*收到消息*/
- (void)messageDidRecieveMessage:(NSNotification*)notic{
    [self refreshTableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQConversationCell * cell = [XQQConversationCell cellForTableView:tableView rowAtIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //拿到好友的model
    XQQConversationModel * conModel = self.dataArr[indexPath.row];
    //会话
    EMConversation * chatConversation = conModel.chatConversation;

    //创建XQQFriendModel
    XQQFriendModel * friendModel = [[XQQFriendModel alloc]init];
    friendModel.userName = conModel.chatter;
    friendModel.nickName = conModel.nickName;
    friendModel.iconImgaeURL = conModel.iconURL;
    friendModel.isOnline = conModel.isOnline;
    //进去聊天页面
    XQQChatViewController * chatVC = [[XQQChatViewController alloc]init];
    chatVC.chatConversation = chatConversation;
    if (chatConversation.conversationType == eConversationTypeGroupChat) {
        chatVC.isGroup = YES;
        chatVC.messageType = eMessageTypeGroupChat;
        EMGroup * chatGroup = [EMGroup groupWithId:chatConversation.chatter];
        chatVC.chatGroup = chatGroup;
    }else{
        chatVC.isGroup = NO;
        chatVC.messageType = eMessageTypeChat;
    }
    //群组
    chatVC.model = friendModel;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除数据源
        XQQConversationModel * model = self.dataArr[indexPath.row];
        [self.dataArr removeObject:model];
        //删除会话
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.chatter deleteMessages:NO append2Chat:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
}

/*修改删除按钮为中文的删除*/
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath{
    return @"删除";
}

/*是否允许编辑行，默认是YES*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
}

#pragma mark - setter&getter

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
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getConversationList)];
        _chatTableView.mj_header = header;
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _chatTableView;
}

@end
