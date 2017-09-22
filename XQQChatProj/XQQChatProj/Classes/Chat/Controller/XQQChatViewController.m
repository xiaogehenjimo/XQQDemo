//
//  XQQChatViewController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/16.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatViewController.h"
#import "XQQChatTitleView.h"
#import "XQQChatCell.h"
#import "XQQVoicePlayAnimationTool.h"


@interface XQQChatViewController ()<chatInputViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,IEMChatProgressDelegate,MWPhotoBrowserDelegate>
/** tableView */
@property(nonatomic, strong)  UITableView  *  chatTableView;
/** 数据源数组 */
@property(nonatomic, strong)  NSMutableArray  *  dataArr;
@end

@implementation XQQChatViewController


#pragma mark - 生命周期

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //拉取这个好友的信息
    
    [[XQQUserInfoTool sharedManager] getOneFriendInfo:_model.userName complete:^(NSArray *array, NSError *error) {
        if (!array.count) {
            return ;
        }
        BmobObject * info = array[0];
        NSString * iconURL = [info objectForKey:@"iconURL"];
        _model.iconImgaeURL = iconURL;
        //取值
        NSString * nickName = [info objectForKey:@"nickName"];
        NSString * userName = [info objectForKey:@"userName"];
        NSNumber * number = [info objectForKey:@"isOnline"];
        BOOL isOnline = number.boolValue;
        
        XQQFriendModel * model = [[XQQFriendModel alloc]init];
        model.nickName = nickName;
        model.userName = userName;
        model.iconImgaeURL = iconURL;
        model.isOnline = isOnline;
        //更新数据库好友信息
        [[XQQDataManager sharedDataManager] updateFriendInfo:model];
    }];
    /*注册收到消息监听*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveMessage:) name:XQQNoticDidRecieveMessage object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XQQNoticDidRecieveMessage object:nil];

    //如果页面退出还在播放语音 停止播放语音
    if ([[EMCDDeviceManager sharedInstance]isPlaying]) {
        [[EMCDDeviceManager sharedInstance] stopPlaying];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    //获取聊天信息 从数据库中
    [self loadMessage];
}

#pragma mark - 历史消息

/*获取历史消息*/
- (void)loadMessage{
    //先获取最新的一条消息
    [_chatConversation markAllMessagesAsRead:YES];
    EMMessage * latestMessage = [_chatConversation latestMessage];
    if (latestMessage) {
        //根据最新的这条消息 加载距离这条消息上面的15条信息
        NSArray * messageArr = [_chatConversation loadNumbersOfMessages:15 withMessageId:latestMessage.messageId];
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:messageArr];
        //[self.dataArr setArray:messageArr];
        [self.dataArr addObject:latestMessage];
        [self refreshTableView];
    }
}

/*下拉加载更多聊天记录*/
- (void)loadMoreMessage{
    //最顶部的一条消息
    EMMessage * message = self.dataArr.firstObject;
    NSArray * moreMessage = [_chatConversation loadNumbersOfMessages:15 withMessageId:message.messageId];
    if (moreMessage.count > 0){
        NSMutableArray * tmpArr = [[NSMutableArray alloc]initWithArray:self.dataArr];
        [self.dataArr setArray:moreMessage];
        [self.dataArr addObjectsFromArray:tmpArr];
        [self.chatTableView reloadData];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:moreMessage.count inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        if ([self.chatTableView.mj_header isRefreshing]) {
            [self.chatTableView.mj_header endRefreshing];
        }
    }else{
        [self.view showToastWithStr:@"没有更多消息了"];
        if ([self.chatTableView.mj_header isRefreshing]) {
            [self.chatTableView.mj_header endRefreshing];
        }
    }
}

#pragma mark - 收到消息

/*收到一条消息*/
- (void)recieveMessage:(NSNotification*)notic{
    EMMessage * message = notic.object;
    [self.dataArr addObject:message];
    [self refreshTableView];
}

#pragma mark - chatInputViewDelegate

/*文字消息编辑完毕 要发送*/
- (void)chatInputViewDidEndEdit:(NSString*)message{
    NSString * sendName = self.isGroup ? self.chatGroup.groupId : _model.userName;
    EMMessage * textMessage = [[XQQMessageTool sharedMessageTool] createTextMessageWithFrindName:sendName Str:message messageType:_messageType];
    [self sendMessage:textMessage];
}

/*语音消息录音完成 要发送*/
- (void)sendVoiceMessage:(NSString *)recordPath
               aDuration:(NSInteger)aDuration{
    NSString * sendName = self.isGroup ? self.chatGroup.groupId : _model.userName;
    //录音完成
    EMMessage * voiceMessage = [[XQQMessageTool sharedMessageTool] createVoiceMessage:recordPath duration:aDuration friendName:sendName messageType:_messageType];
    [self sendMessage:voiceMessage];
}

/*发送图片消息*/
- (void)sendImageMessage:(UIImage*)image{
    NSString * sendName = self.isGroup ? self.chatGroup.groupId : _model.userName;
    EMMessage * imageMessage = [[XQQMessageTool sharedMessageTool] createImageMessageWithFrindName:sendName sendImage:image messageType:_messageType];
    [self sendMessage:imageMessage];
}

/*发送位置消息*/
- (void)sendLocationMessage:(BMKPoiInfo*)locationModel{
    NSString * sendName = self.isGroup ? self.chatGroup.groupId : _model.userName;
    EMMessage * locationMessage = [[XQQMessageTool sharedMessageTool] createLocationMessage:sendName locationModel:locationModel messageType:_messageType];
    [self sendMessage:locationMessage];
}

/*发送消息方法*/
- (void)sendMessage:(EMMessage*)message{
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self prepare:^(EMMessage *message, EMError *error) {
        XQQLog(@"正在发送");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        [self.dataArr addObject:message];
        [self.chatTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } onQueue:nil];
}

/*改变self.view高度*/
- (void)changeViewHeight:(CGFloat)height{
    self.view.xqq_y = height;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_inputView resignResponder];
}

#pragma mark - IEMChatProgressDelegate

- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody{
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    EMImageMessageBody *body = self.imageMessage.messageBodies[0];
    NSString *path = body.localPath;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:path]) {
        // 设置图片浏览器中的图片对象 (本地获取的)
        return [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:path]];
    }else{
        // 设置图片浏览器中的图片对象 (使用网络请求)
        path = body.remotePath;
        return [MWPhoto photoWithURL:[NSURL URLWithString:path]];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQChatCell * cell = [XQQChatCell cellForTableView:tableView indexPath:indexPath];
    cell.friendModel = self.model;
    cell.conversation = self.chatConversation;
    cell.message = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.chatBtn.block = ^(XQQChatBtn* button){
        [weakSelf chatContentDidPress:indexPath button:button];
    };
    cell.chatBtn.longPressBlock = ^(XQQChatBtn*button){
        
        
    };
    return cell;
}


- (void)relay{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQChatCell * cell = [XQQChatCell cellForTableView:tableView indexPath:indexPath];
    cell.friendModel = self.model;
    cell.conversation = self.chatConversation;
    cell.message = self.dataArr[indexPath.row];
    return cell.cellHeight;
}

#pragma mark - activity

/*聊天内容按钮点击了*/
- (void)chatContentDidPress:(NSIndexPath*)indexPath
                     button:(XQQChatBtn*)button{
    EMMessage * message = self.dataArr[indexPath.row];
    [[XQQChatJumpTool sharedTool] disposeMessage:message vc:self button:button];
}

/*刷新表格*/
- (void)refreshTableView{
    [self.chatTableView reloadData];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - setter&getter

/*UI*/
- (void)initUI{
    //聊天的tableView
    _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight - 50) style:UITableViewStylePlain];
    //_chatTableView.backgroundColor = [UIColor redColor];
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //下拉加载更多聊天记录
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessage)];
    [header setTitle:@"下拉加载更多记录" forState:MJRefreshStateIdle];//闲置
    [header setTitle:@"松开加载更多记录" forState:MJRefreshStatePulling];//松开就开始刷新
    [header setTitle:@"正在加载记录" forState:MJRefreshStateRefreshing];//正在刷新中
    //[header setTitle:@"" forState:MJRefreshStateWillRefresh];//将要刷新
    [header setTitle:@"没有更多消息了" forState:MJRefreshStateNoMoreData];//没有数据了
    _chatTableView.mj_header = header;
    [self.view addSubview:_chatTableView];
    
    self.navigationItem.title = @"聊天";
    XQQChatTitleView * titleView = [[XQQChatTitleView alloc]initWithFrame:CGRectMake((iphoneWidth - 200)/2, 0, 200, 40)];
    if (self.isGroup) {
        titleView.infoDict = @{@"model":@"",@"group":self.chatGroup};
    }else{
        if (self.model) {
            titleView.infoDict = @{@"model":self.model,@"group":@""};
        }
    }
    self.navigationItem.titleView = titleView;
    //下方的输入框
    _inputView = [[XQQChatInputView alloc]initWithFrame:CGRectMake(0, iphoneHeight - 50, iphoneWidth, 50)];
    _inputView.delegate = self;
    [self.view addSubview:_inputView];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

@end
