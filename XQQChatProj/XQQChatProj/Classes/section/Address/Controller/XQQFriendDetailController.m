//
//  XQQFriendDetailController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/17.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQFriendDetailController.h"
#import "XQQDetailCell.h"
#import "XQQChatViewController.h"
#import "XQQNavigationController.h"
#import "XQQCallViewController.h"

@interface XQQFriendDetailController ()<UITableViewDelegate,UITableViewDataSource,EMCallManagerDelegate>
/*列表*/
@property(nonatomic, strong)  UITableView * myTableView;
/** 数据 */
@property(nonatomic, strong)  NSMutableArray  *  dataArr;
/** footView */
@property(nonatomic, strong)  UIView  *  footView;
/** 发消息按钮 */
@property(nonatomic, strong)  UIButton  *  sendMessageBtn;
/** 视频聊天按钮 */
@property(nonatomic, strong)  UIButton  *  videoChatBtn;
/** 语音按钮 */
@property(nonatomic, strong)  UIButton  *  voiceChatBtn;
@end

@implementation XQQFriendDetailController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
}

/*创建UI*/
- (void)initUI{
    self.navigationItem.title = @"详细资料";
    
    NSArray * tmpArr = @[@[@{@"name":_buddy.userName,@"nickName":_buddy.nickName,@"iconURL":_buddy.iconImgaeURL}],//个人信息 以后可以增加
                         ];
    [self.dataArr setArray:tmpArr];
    [self.view addSubview:self.myTableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * arr = self.dataArr[section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"otherCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.section == 0) {
        //加载第一个cell
        XQQDetailCell * detailCell = [XQQDetailCell cellForTableView:tableView indexPath:indexPath];
        detailCell.infoDict = self.dataArr[indexPath.section][indexPath.row];
        
        return detailCell;
    }else if (indexPath.section == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary * dict = self.dataArr[indexPath.section][indexPath.row];
        
        cell.textLabel.text = dict.allKeys.firstObject;
        return cell;
    }else if(indexPath.section == 1){
        cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100.0;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view showToastWithStr:@"请选择聊天类型"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - activity
/*发送消息按钮点击*/
- (void)sendMessageBtnDidPress:(UIButton*)button{
    //消息页面
    XQQChatViewController * chatVC = [[XQQChatViewController alloc]init];
    ;
    self.tabBarController.selectedIndex = 0;
    //消息页面
    XQQNavigationController * messageVC = self.tabBarController.selectedViewController;
    //创建一个会话
    chatVC.chatConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.userName conversationType:eConversationTypeChat];
    chatVC.model = self.buddy;
    //单聊
    chatVC.isGroup = NO;
    chatVC.messageType = eMessageTypeChat;
    chatVC.hidesBottomBarWhenPushed = YES;
    [messageVC pushViewController:chatVC animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

/*视频按钮点击*/
- (void)videoBtnDidPress:(UIButton*)button{
    
    BOOL isopen = [[XQQMessageTool sharedMessageTool] canVideo];
    if (!isopen) {
        NSLog(@"不能打开视频");
        return ;
    }
    // 添加实时通话代理
    [[XQQMessageTool sharedMessageTool] removeDelegateConnect];
    [[XQQMessageTool sharedMessageTool] addCallDelegate];
    [[XQQMessageTool sharedMessageTool] callOutWithChatter:@{@"chatter":self.buddy.userName, @"type":@"eCallSessionTypeVideo"}];
}
/*语音按钮点击*/
- (void)voiceBtnDidPress:(UIButton*)button{
    [[XQQMessageTool sharedMessageTool] callOutWithChatter:@{@"chatter":self.buddy.userName, @"type":@"eCallSessionTypeAudio"}];
}

#pragma mark - setter&getter

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        //脚视图
        _footView = [[UIView alloc]init];
        _footView.backgroundColor = [UIColor clearColor];
        //发消息按钮
        _sendMessageBtn = [[UIButton alloc]initWithFrame:CGRectMake(iphoneWidth/4, 10, iphoneWidth/2, 44)];
        _sendMessageBtn.layer.cornerRadius = 10.0;
        _sendMessageBtn.layer.masksToBounds = YES;//37  167  39
        //34  153  35
        //
        _sendMessageBtn.backgroundColor = XQQColor(37, 167, 39);
        //        [_sendMessageBtn setBackgroundImage:[[UIImage imageNamed:@"setting_verify"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        //        [_sendMessageBtn setBackgroundImage:[UIImage imageNamed:@"setting_verifyPressed"] forState:UIControlStateHighlighted];
        [_sendMessageBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [_sendMessageBtn addTarget:self action:@selector(sendMessageBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [_sendMessageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_footView addSubview:_sendMessageBtn];
        //视频按钮
        _videoChatBtn = [[UIButton alloc]initWithFrame:CGRectMake(iphoneWidth/4, CGRectGetMaxY(_sendMessageBtn.frame) + 10, iphoneWidth/2, 44)];
        _videoChatBtn.layer.cornerRadius = 10.0;
        _videoChatBtn.layer.masksToBounds = YES;
        // _videoChatBtn.backgroundColor = [UIColor whiteColor];
        [_videoChatBtn setTitle:@"视频通话" forState:UIControlStateNormal];
        [_videoChatBtn setBackgroundImage:[UIImage imageNamed:@"watch-setting-button"] forState:UIControlStateNormal];
        [_videoChatBtn setBackgroundImage:[UIImage imageNamed:@"watch-setting-button-selected"] forState:UIControlStateHighlighted];
        [_videoChatBtn addTarget:self action:@selector(videoBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [_videoChatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _videoChatBtn.layer.borderWidth = 1;
        _videoChatBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_footView addSubview:_videoChatBtn];
        //语音按钮
        _voiceChatBtn = [[UIButton alloc]initWithFrame:CGRectMake(iphoneWidth/4, CGRectGetMaxY(_videoChatBtn.frame) + 10, iphoneWidth/2, 44)];
        _voiceChatBtn.layer.cornerRadius = 10.0;
        _voiceChatBtn.layer.masksToBounds = YES;
        // _videoChatBtn.backgroundColor = [UIColor whiteColor];
        [_voiceChatBtn setTitle:@"语音通话" forState:UIControlStateNormal];
        [_voiceChatBtn setBackgroundImage:[UIImage imageNamed:@"watch-setting-button"] forState:UIControlStateNormal];
        [_voiceChatBtn setBackgroundImage:[UIImage imageNamed:@"watch-setting-button-selected"] forState:UIControlStateHighlighted];
        [_voiceChatBtn addTarget:self action:@selector(voiceBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceChatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _voiceChatBtn.layer.borderWidth = 1;
        _voiceChatBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_footView addSubview:_voiceChatBtn];
        
        
        _footView.frame = CGRectMake(0, 0, iphoneWidth, CGRectGetMaxY(_voiceChatBtn.frame) + 10);
        _myTableView.tableFooterView = _footView;
    }
    return _myTableView;
}
@end
