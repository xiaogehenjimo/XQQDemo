//
//  XQQAddFriendController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/17.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQAddFriendController.h"
#import "XQQFriendModel.h"
#import "XQQSearchCell.h"
#import "XQQAddInfoController.h"

typedef NS_ENUM(NSInteger,searchFriendType){
    searchFriendTypeNickName = 0,
    searchFriendTypeID
};

@interface XQQAddFriendController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
/**添加好友输入框*/
@property(nonatomic, strong)  UITextField * addFriendTextField;
/** 搜索按钮 */
@property(nonatomic, strong)  UIButton    *  searchBtn;
/** 网络请求loading */
@property(nonatomic, assign)  BOOL   isLoading;
/** 搜索结果的tableView */
@property(nonatomic, strong)  UITableView  *  resultTableView;
/** 查询的数据源 */
@property(nonatomic, strong)  NSMutableArray  *  dataArr;
/** 记录查询好友的类型 */
@property(nonatomic, assign)  searchFriendType   searchType;
/** 查询失败的View */
@property(nonatomic, strong)  UIView  *  failView;
@end

@implementation XQQAddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - UITextFieldDelegate


#pragma mark - activity

/*处理查询到的好友信息*/
- (void)disposeData:(NSArray*)array
              error:(NSError*)error{
    if (array.count > 0) {//存在这个用户
        [self.dataArr removeAllObjects];
        for (BmobObject * obj in array) {
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
            [self.dataArr addObject:model];
        }
        self.resultTableView.hidden = NO;
        self.failView.hidden = YES;
        [self.resultTableView reloadData];
        _isLoading = NO;
    }else{//隐藏tableView  显示失败的页面
        self.resultTableView.hidden = YES;
        self.failView.hidden = NO;
        _isLoading = NO;
    }
}

/*搜索按钮点击了*/
- (void)searchBtnDidPress:(UIButton*)button{
    [self.addFriendTextField resignFirstResponder];
    if (_addFriendTextField.text.length > 0) {
        if (_isLoading) {
            return;
        }
        _isLoading = YES;
        
        XQQUserInfoTool * userInfoTool = [XQQUserInfoTool sharedManager];
        
        if (self.searchType == searchFriendTypeID) {
            [userInfoTool getOneFriendInfo:_addFriendTextField.text complete:^(NSArray *array, NSError *error) {
                [self disposeData:array error:error];
            }];
        }else{
            [userInfoTool getUserInfoWithNickName:_addFriendTextField.text complete:^(NSArray *array, NSError *error) {
                [self disposeData:array error:error];
            }];
        }
        self.addFriendTextField.text = @"";
    }else{
        if (self.searchType == searchFriendTypeID) {
            [self.view showToastWithStr:@"请输入好友账号"];
        }else{
            [self.view showToastWithStr:@"请输入好友名称"];
        }
    }
}

- (void)segmentChange:(UISegmentedControl*)segament{
    self.addFriendTextField.placeholder = segament.selectedSegmentIndex == 0 ? @"请输入好友昵称" : @"请输入好友账号";
    _searchType = segament.selectedSegmentIndex;
//    self.resultTableView.hidden = YES;
//    [self.dataArr removeAllObjects];
//    self.failView.hidden = YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQSearchCell * cell = [XQQSearchCell cellForTableView:tableView indexPath:indexPath];
    cell.cellWidth = self.resultTableView.xqq_width;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XQQFriendModel * friendModel = self.dataArr[indexPath.row];
    //判断此好友是不是当前登录的用户的好友
    if ([friendModel.userName isEqualToString:[XQQManager sharedManager].userName]) {
        [self.view showToastWithStr:@"不可以添加自己哦~~"];
    }else if ([[XQQDataManager sharedDataManager] searchFriendWithUserName:friendModel.userName]) {
        [self.view showToastWithStr:@"ta已经是你的好友啦~"];
    }else{
        
        XQQAddInfoController * addInfoVC = [[XQQAddInfoController alloc]init];
        addInfoVC.friendModel = friendModel;
        
        [self.navigationController pushViewController:addInfoVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.resultTableView.xqq_width, 30)];
    view.textAlignment = NSTextAlignmentCenter;
    view.text = @"为您找到了如下符合信息的用户";
    view.font = [UIFont systemFontOfSize:14];
    view.textColor = XQQColor(132, 122, 87);
    //view.backgroundColor = [UIColor redColor];
    return view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.addFriendTextField resignFirstResponder];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.addFriendTextField resignFirstResponder];
}

#pragma mark - setter&getter

/*创建UI*/
- (void)initUI{
    self.navigationItem.title = @"查找用户";
    //昵称 账号 选择
    UISegmentedControl * segment = [[UISegmentedControl alloc]initWithItems:@[@"昵称查询",@"账号查询"]];
    segment.selectedSegmentIndex = 0;
    segment.tintColor = XQQColor(123, 123, 123);
    segment.frame = CGRectMake((iphoneWidth - 150) * 0.5, 80, 150, 44);
    [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
    _addFriendTextField = [[UITextField alloc]initWithFrame:CGRectMake(iphoneWidth /4 - 40 , segment.xqq_bottom + 10, iphoneWidth/2, 40)];
    _addFriendTextField.delegate = self;
    _addFriendTextField.font = [UIFont systemFontOfSize:18];
    UIImageView * leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftView.image = [UIImage imageNamed:@"SearchContactsBarIcon"];
    
    _addFriendTextField.leftView = leftView;
    _addFriendTextField.leftViewMode = UITextFieldViewModeAlways;
    _addFriendTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _addFriendTextField.borderStyle = UITextBorderStyleRoundedRect;
    _addFriendTextField.backgroundColor = [UIColor whiteColor];
    _addFriendTextField.placeholder = @"请输入好友昵称";
    [self.view addSubview:_addFriendTextField];
    
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_addFriendTextField.frame) + 10, _addFriendTextField.frame.origin.y, 80, 40)];
    _searchBtn.backgroundColor = XQQColor(83, 140, 198);
    _searchBtn.layer.cornerRadius = 10.0;
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.layer.borderWidth = 0.5;
    [_searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [_searchBtn setTitle:@"查询" forState:UIControlStateHighlighted];
    _searchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [_searchBtn addTarget:self action:@selector(searchBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
    
    
    [self.view addSubview:self.resultTableView];
    self.resultTableView.hidden = YES;
    
    [self.view addSubview:self.failView];
    self.failView.hidden = YES;
    //查询的类型
    self.searchType = 0;
}

- (UITableView *)resultTableView{
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.addFriendTextField.xqq_x, self.addFriendTextField.xqq_bottom + 10, self.addFriendTextField.xqq_width + 10 + self.searchBtn.xqq_width, 300) style:UITableViewStylePlain];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _resultTableView;
}

- (UIView *)failView{
    if (!_failView) {
        _failView = [[UIView alloc]initWithFrame:CGRectMake(0, self.addFriendTextField.xqq_bottom + 10, iphoneWidth, 350)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _failView.xqq_width, _failView.xqq_height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:@"failImage"];
        [_failView addSubview:imageView];
        _failView.backgroundColor = [UIColor yellowColor];
    }
    return _failView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}
@end
