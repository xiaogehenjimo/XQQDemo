//
//  XQQAddGroupController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/2.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQAddGroupController.h"
#import "MainViewController.h"
#import "XQQFriendModel.h"
#import "XQQGroupFriendCell.h"
#import "XQQGroupTopScrollView.h"
#import "XQQChatViewController.h"
#import "XQQNavigationController.h"
#import "XQQLookGroupController.h"
@interface XQQAddGroupController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
/** 顶部显示头像的滚动视图 */
@property(nonatomic, strong)  XQQGroupTopScrollView  *  topScrollView;
/**数据源*/
@property(nonatomic, strong)  NSMutableArray *  dataArr;
/** 列表 */
@property(nonatomic, strong)  UITableView    *  chatTableView;
/** 选中人员数组 */
@property(nonatomic, strong)  NSMutableArray  *  selFriendList;
/** 右上角确定按钮 */
@property(nonatomic, strong)  UIButton  *  sureBtn;
/** 左上角返回按钮 */
@property(nonatomic, strong)  UIButton  *  backBtn;
@end

@implementation XQQAddGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    /*获取好友列表*/
    [self getFriendList];
    /*获取群聊列表*/
    //[self getGroupList];
}

/*获取好友列表*/
- (void)getFriendList{
    //本地数据库查找好友
    NSArray * friendArr = [[XQQDataManager sharedDataManager] searchAllFriend];
    for (XQQFriendModel * model in friendArr) {
        model.isSel = NO;
    }
    if (friendArr.count > 0) {
        [self.dataArr addObjectsFromArray:friendArr];
        [self.chatTableView reloadData];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"滚动视图在滚动...");
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        static NSString * cellID = @"1233";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            if (indexPath.row == 0) {
               cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = self.dataArr[indexPath.row];
        return cell;
    }else{
        XQQGroupFriendCell * cell = [XQQGroupFriendCell cellForTableView:tableView indexPath:indexPath];
        XQQFriendModel * model = self.dataArr[indexPath.row];
        cell.model = model;
        cell.didSelected = ^(XQQFriendModel * friendModel,BOOL isSel){
            [self cellSelBtnDidSel:friendModel isSel:isSel];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        XQQLookGroupController * lookVC = [[XQQLookGroupController alloc]init];
        lookVC.dissmissVC = ^(){
            [self dismissViewControllerAnimated:NO completion:nil];
        };
        [self.navigationController pushViewController:lookVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        return 44;
    }else{
        return 70.0;
    }
}

#pragma mark - activity

/*根据名字和介绍创建群*/
- (void)createGroupWithName:(NSString*)name
                  introduce:(NSString*)introduce{
    
    EMGroupStyleSetting *groupSetting = [[EMGroupStyleSetting alloc]init];
    // 设置群里的类型
    groupSetting.groupStyle = eGroupStyle_PublicOpenJoin;
    // 设置群组最多容纳多少人
    groupSetting.groupMaxUsersCount = 400;
    
    //要加入的成员
    NSMutableArray * nameArr = @[].mutableCopy;
    for (XQQFriendModel* model in self.selFriendList) {
        [nameArr addObject:model.userName];
    }
    UIWindow * window = [[XQQManager sharedManager] getWindow];
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:name description:introduce invitees:nameArr initialWelcomeMessage:@"欢迎加入群聊!" styleSetting:groupSetting completion:^(EMGroup *group, EMError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"创建成功"];
            //跳转到群聊界面
            XQQChatViewController * chatVC = [[XQQChatViewController alloc]init];
            MainViewController * mainVC = (MainViewController*)window.rootViewController;
            mainVC.selectedIndex = 0;
            //消息页面
            XQQNavigationController * messageVC = mainVC.selectedViewController;
            //创建一个会话
            chatVC.chatConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:group.groupId conversationType:eConversationTypeGroupChat];
            chatVC.chatGroup = group;
            chatVC.isGroup = YES;
            chatVC.messageType = eMessageTypeGroupChat;
            chatVC.hidesBottomBarWhenPushed = YES;
            [MBProgressHUD hideHUDForView:window animated:YES];
            [messageVC pushViewController:chatVC animated:YES];
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }else{
            [MBProgressHUD hideHUDForView:window animated:YES];
            [SVProgressHUD showErrorWithStatus:@"创建失败"];
        }
    } onQueue:nil];
}

/*返回按钮点击了*/
- (void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*确定按钮点击*/
- (void)sureBtnClicked:(UIButton*)button{
    if (self.selFriendList.count == 1) {
        [self.view showToastWithStr:@"群聊需要邀请2个以上的好友哦~"];
        return;
    }
    //创建群聊
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"给可爱的群起个萌萌的名字吧~" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        textField.placeholder = @"群名字";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        textField.placeholder = @"介绍";
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * sureAct = [UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       //确定点击了 先移除监听
         [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        //拿到输入框的值
        NSString * groupName = alertController.textFields.firstObject.text;
        NSString * introduce = alertController.textFields.lastObject.text;
        [self createGroupWithName:groupName introduce:introduce];
    }];
    sureAct.enabled = NO;
    [alertController addAction:cancel];
    [alertController addAction:sureAct];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

/*文本框的内容*/
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *nameText = alertController.textFields.firstObject;
        UITextField *introduce = alertController.textFields.lastObject;
        //确定
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = nameText.text.length > 0 &&introduce.text.length > 0;
    }
}


/*cell被选中或未选中*/
- (void)cellSelBtnDidSel:(XQQFriendModel*)friendModel
                   isSel:(BOOL)isSel{
    
    NSInteger  index = [self.dataArr indexOfObject:friendModel];
    XQQFriendModel * friend = self.dataArr[index];
    friend.isSel = isSel;
    
    
    if (isSel) {
        //滚动视图添加头像
        [self.selFriendList addObject:friendModel];
    }else{
        //滚动视图添加头像
        if ([self.selFriendList containsObject:friendModel]) {
            [self.selFriendList removeObject:friendModel];
        }
    }
    _topScrollView.selFriendArr = self.selFriendList;
    if (self.selFriendList.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - setter&getter
/*UI*/
- (void)initUI{
    self.navigationItem.title = @"选择联系人";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建显示头像的滚动视图
    _topScrollView = [[XQQGroupTopScrollView alloc]initWithFrame:CGRectMake(0, 64, iphoneWidth, 60)];
    _topScrollView.delegate = self;
    [self.view addSubview:_topScrollView];
    [self.dataArr setArray:@[@"选择一个群",@""]];
    [self.view addSubview:self.chatTableView];
    //左上角返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    //右上角确定按钮
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.sureBtn];
        rightItem.enabled = NO;
        rightItem;
    });
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

- (UITableView *)chatTableView{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _topScrollView.xqq_bottom, iphoneWidth, iphoneHeight - _topScrollView.xqq_height - 64) style:UITableViewStylePlain];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _chatTableView;
}
//- (UIButton *)backBtn{
//    if (!_backBtn) {
//        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [_backBtn setTitle:@"消息" forState:UIControlStateNormal];
//        [_backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _backBtn.tag = 34567;
//        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _backBtn;
//}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _sureBtn.tag = 23456;
        [_sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (NSMutableArray *)selFriendList{
    if (!_selFriendList) {
        _selFriendList = @[].mutableCopy;
    }
    return _selFriendList;
}
@end
