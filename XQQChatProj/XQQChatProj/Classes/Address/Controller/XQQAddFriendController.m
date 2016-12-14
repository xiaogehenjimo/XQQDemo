//
//  XQQAddFriendController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/17.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQAddFriendController.h"

@interface XQQAddFriendController ()<UITextFieldDelegate>
/**添加好友输入框*/
@property(nonatomic, strong)  UITextField * addFriendTextField;
/** 搜索按钮 */
@property(nonatomic, strong)  UIButton    *  searchBtn;
/** 网络请求loading */
@property(nonatomic, assign)  BOOL   isLoading;



@end

@implementation XQQAddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - UITextFieldDelegate


#pragma mark - activity

/*搜索按钮点击了*/
- (void)searchBtnDidPress:(UIButton*)button{
    if (_addFriendTextField.text.length > 0) {
        if (_isLoading) {
            return;
        }
        _isLoading = YES;
        
        BOOL isSuc = [[EaseMob sharedInstance].chatManager addBuddy:_addFriendTextField.text message:@"是否可以添加你为好友?" error:nil];
        if (isSuc) {
            [self.view showToastWithStr:@"发送成功"];
            _addFriendTextField.text = @"";
            _isLoading = NO;
        }else{
            [self.view showToastWithStr:@"发送失败"];
            _isLoading = NO;
        }
    }else{
        [self.view showToastWithStr:@"请输入好友名称"];
    }
}


#pragma mark - setter&getter

/*创建UI*/
- (void)initUI{
    self.navigationItem.title = @"添加好友";
    _addFriendTextField = [[UITextField alloc]initWithFrame:CGRectMake(iphoneWidth /4 - 40 , 100, iphoneWidth/2, 40)];
    _addFriendTextField.delegate = self;
    _addFriendTextField.font = [UIFont systemFontOfSize:18];
    UIImageView * leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftView.image = [UIImage imageNamed:@"SearchContactsBarIcon"];
    
    _addFriendTextField.leftView = leftView;
    _addFriendTextField.leftViewMode = UITextFieldViewModeAlways;
    _addFriendTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _addFriendTextField.borderStyle = UITextBorderStyleRoundedRect;
    _addFriendTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_addFriendTextField];
    
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_addFriendTextField.frame) + 10, _addFriendTextField.frame.origin.y, 80, 40)];
    _searchBtn.backgroundColor = XQQColor(83, 140, 198);
    _searchBtn.layer.cornerRadius = 10.0;
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.layer.borderWidth = 0.5;
    [_searchBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_searchBtn setTitle:@"发送" forState:UIControlStateHighlighted];
    _searchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [_searchBtn addTarget:self action:@selector(searchBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
}


@end
