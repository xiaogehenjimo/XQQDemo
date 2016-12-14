//
//  XQQLoginViewController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQLoginViewController.h"
#import "XQQLoginTextField.h"
#import "AppDelegate.h"
@interface XQQLoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
/**背景*/
@property(nonatomic, strong)  UIImageView   *  backImageView;
/** 顶部滚动视图 */
@property(nonatomic, strong)  UIScrollView  *  topScrollView;
/** 顶部右侧的注册账号按钮 */
@property(nonatomic, strong)  UIButton      *  rightBtn;
/** 顶部按钮是否选中 */
@property(nonatomic, assign)  BOOL             rightBtnDidPress;
/** 登录的View */
@property(nonatomic, strong)  UIView        *  loginView;
/** 登录用户名输入框 */
@property(nonatomic, strong)  XQQLoginTextField   *  loginUserNameText;
/** 登录密码 */
@property(nonatomic, strong)  XQQLoginTextField   *  loginPassWordText;
/** 登录按钮 */
@property(nonatomic, strong)  UIButton      *  loginBtn;
/** 注册的View */
@property(nonatomic, strong)  UIView        *  registView;
/** 注册的用户名 */
@property(nonatomic, strong)  XQQLoginTextField   *  registUserNameText;
/** 注册的密码 */
@property(nonatomic, strong)  XQQLoginTextField   *  registPassWordText;
/** 确认密码 */
@property(nonatomic, strong)  XQQLoginTextField   *  verifyTextField;
/** 注册的按钮 */
@property(nonatomic, strong)  UIButton      *  registBtn;

@end

@implementation XQQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

/*创建UI*/
- (void)initUI{
    _rightBtnDidPress = NO;
    [self.view addSubview:self.backImageView];
    //顶部右侧的按钮
    [self.view addSubview:self.rightBtn];
    //顶部的滚动视图
    [self.view addSubview:self.topScrollView];
}

#pragma mark - activity

- (void)rightBtnDidPress:(UIButton*)button{
    if (_rightBtnDidPress) {
        [_rightBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        [self.topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _rightBtnDidPress = NO;
    }else{//已有账号
        [_rightBtn setTitle:@"已有账号" forState:UIControlStateNormal];
        [self.topScrollView setContentOffset:CGPointMake(iphoneWidth, 0) animated:YES];
        _rightBtnDidPress = YES;
    }
    [self resignFirst];
    [self removeText];
}

/*清空输入框*/
- (void)removeText{
    self.loginPassWordText.text = @"";
    self.loginUserNameText.text = @"";
    self.registPassWordText.text = @"";
    self.registUserNameText.text = @"";
    self.verifyTextField.text = @"";
}
/**登录按钮点击了*/
- (void)loginBtnDidPress:(UIButton*)button{
    [self resignFirst];
    
    if ([_loginUserNameText.text isEqualToString:@""] || _loginUserNameText.text.length == 0) {
        [self.view showToastWithStr:@"用户名不能为空"];
        return;
    }
    if ([_loginPassWordText.text isEqualToString:@""]||_loginPassWordText.text.length == 0) {
        [self.view showToastWithStr:@"密码不能为空"];
        return;
    }
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_loginUserNameText.text password:_loginPassWordText.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            NSLog(@"登录成功");
            //保存账号
            [XQQUtility archiveData:@[_loginUserNameText.text] IntoCache:@"userName"];
            [XQQManager sharedManager].userName = _loginUserNameText.text;
            //跳转主页面 重置根视图
            AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate jumpToMainVC];
            //设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            [XQQManager sharedManager].isAutoLogin = YES;
            /*创建用户关联的表*/
            [self createUserTableWithName:_loginUserNameText.text];
            //更新用户在线状态
            [[XQQUserInfoTool sharedManager] changeMyStates:YES];
            //开始接受好友申请 与信息
            //[[XQQMessageTool sharedMessageTool] buildDelegateConnect];
        }else{
            if ([error.description isEqualToString:@"User do not exist."]) {
                [self.view showToastWithStr:@"用户不存在"];
            }else if ([error.description isEqualToString:@"User name or password is incorrect."]){
                [self.view showToastWithStr:@"用户名或密码错误"];
            }else{
                [self.view showToastWithStr:@"登录失败,请尝试再次登录"];
            }
        }
    } onQueue:nil];
}

/*创建用户关联的表*/
- (void)createUserTableWithName:(NSString*)name{
    //创建数据库
    [[XQQDataManager sharedDataManager] createDataBaseWithUserName:name];
    //创建好友表
    [[XQQDataManager sharedDataManager]createUserFriendListWithUserName:name];
    //创建好友消息表
    [[XQQDataManager sharedDataManager] createTableWithStr:name];
    //创建个人信息表
    [[XQQDataManager sharedDataManager] createPersonInfoTableWithUserName:name];
}


/**注册按钮点击了*/
- (void)registBtnDidPress:(UIButton*)button{
    [self resignFirst];
    if ([_registUserNameText.text isEqualToString:@""] || _registUserNameText.text.length == 0) {
        [self.view showToastWithStr:@"用户名不能为空"];
        return;
    }
    if ([_registPassWordText.text isEqualToString:@""] || _registPassWordText.text.length == 0) {
        [self.view showToastWithStr:@"密码不能为空"];
        return;
    }
    if ([_verifyTextField.text isEqualToString:@""]|| _verifyTextField.text.length == 0) {
        [self.view showToastWithStr:@"请确认您的密码"];
        return;
    }
    if (![_registPassWordText.text isEqualToString:_verifyTextField.text]) {
        [self.view showToastWithStr:@"两次密码不一致" ];
        return;
    }
    //密码都有了
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_registUserNameText.text password:_registPassWordText.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            //bmob 添加用户
            [[XQQUserInfoTool sharedManager] addUser:_registUserNameText.text];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"恭喜您!" message:@"账号注册成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                [_rightBtn setTitle:@"注册账号" forState:UIControlStateNormal];
                _rightBtnDidPress = NO;
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }else{
            if ([error.description isEqualToString:@"Username already exists."]) {
                [self.view showToastWithStr:@"用户已存在"];
            }else if ([error.description isEqualToString:@"Invalid username."]){
                [self.view showToastWithStr:@"账号格式不对"];
            }else{
                [self.view showToastWithStr:@"账号注册失败"];
            }
            [self removeText];
        }
    } onQueue:nil];
}

/**释放第一响应者*/
- (void)resignFirst{
    [self.loginPassWordText resignFirstResponder];
    [self.loginUserNameText resignFirstResponder];
    [self.registPassWordText resignFirstResponder];
    [self.registUserNameText resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignFirst];
}

#pragma mark - setter&gettre
- (XQQLoginTextField*)createTextFieldWithFrame:(CGRect)frame
                                 PlaceHolder:(NSString*)placeHolder{
    XQQLoginTextField * text = [[XQQLoginTextField alloc]initWithFrame:frame];
    text.backgroundColor = XQQColorAlpa(240, 240, 240, 150);
    text.textColor = [UIColor whiteColor];
    text.font = [UIFont systemFontOfSize:15];
    text.delegate = self;
    text.layer.cornerRadius = 8.0;
    text.layer.masksToBounds = YES;
    text.placeholder = placeHolder;
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.clearButtonMode = UITextFieldViewModeWhileEditing;
    //左侧占位view
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 30, 30)];
    text.leftView = leftView;
    text.leftViewMode = UITextFieldViewModeAlways;
    return text;
}

- (UIView *)registView{
    if (!_registView) {
        _registView = [[UIView alloc]init];
        _registUserNameText = [self createTextFieldWithFrame:CGRectMake((iphoneWidth - 250)/2, 20, 250, 46) PlaceHolder:@"请输入用户名"];
        [_registView addSubview:_registUserNameText];
        
        _registPassWordText = [self createTextFieldWithFrame:CGRectMake((iphoneWidth - 250)/2, CGRectGetMaxY(_registUserNameText.frame) + 15, 250, 46) PlaceHolder:@"请输入密码"];
        _registPassWordText.secureTextEntry = YES;
        [_registView addSubview:_registPassWordText];
        
        //确认密码
        _verifyTextField = [self createTextFieldWithFrame:CGRectMake((iphoneWidth - 250)/2, CGRectGetMaxY(_registPassWordText.frame) + 15, 250, 46) PlaceHolder:@"确认您的密码"];
        _verifyTextField.secureTextEntry = YES;
        [_registView addSubview:_verifyTextField];
        //登录按钮
        _registBtn = [[UIButton alloc]initWithFrame:CGRectMake((iphoneWidth - 230)/2, CGRectGetMaxY(_verifyTextField.frame) + 30, 230, 44)];
        [_registBtn setBackgroundImage:[UIImage imageNamed:@"login_register_button"] forState:UIControlStateNormal];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registBtn addTarget:self action:@selector(registBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        _registBtn.layer.cornerRadius = 8.0;
        _registBtn.layer.masksToBounds = YES;
        [_registView addSubview:_registBtn];
        _registView.frame = CGRectMake(iphoneWidth, 0, iphoneWidth, CGRectGetMaxY(_registBtn.frame) + 10);
    }
    return _registView;
}

- (UIView *)loginView{
    if (!_loginView) {
        _loginView = [[UIView alloc]init];
        //输入框 250  46
        _loginUserNameText = [self createTextFieldWithFrame:CGRectMake((iphoneWidth - 250)/2, 20, 250, 46) PlaceHolder:@"请输入用户名"];
        [_loginView addSubview:_loginUserNameText];
        
        _loginPassWordText = [self createTextFieldWithFrame:CGRectMake((iphoneWidth - 250)/2, CGRectGetMaxY(_loginUserNameText.frame) + 15, 250, 46) PlaceHolder:@"请输入密码"];
        _loginPassWordText.secureTextEntry = YES;
        [_loginView addSubview:_loginPassWordText];
        
        //登录按钮
        _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake((iphoneWidth - 230)/2, CGRectGetMaxY(_loginPassWordText.frame) + 30, 230, 44)];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_register_button"] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.layer.cornerRadius = 8.0;
        _loginBtn.layer.masksToBounds = YES;
        [_loginView addSubview:_loginBtn];
        _loginView.frame = CGRectMake(0, 0, iphoneWidth, CGRectGetMaxY(_loginBtn.frame) + 10);
    }
    return _loginView;
}

- (UIScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc]init];
        _topScrollView.delegate = self;
        [_topScrollView addSubview:self.loginView];
        [_topScrollView addSubview:self.registView];
        _topScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.rightBtn.frame) + 30, iphoneWidth, self.registView.frame.size.height);
        _topScrollView.pagingEnabled = YES;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.contentSize = CGSizeMake(2 * iphoneWidth, self.registView.frame.size.height);
        _topScrollView.scrollEnabled = NO;
    }
    return _topScrollView;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(iphoneWidth -10 - 80, 40, 80, 40)];
        [_rightBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.xqq_width, self.view.xqq_height)];
        _backImageView.image = [UIImage imageNamed:@"login_register_background"];
    }
    return _backImageView;
}

@end
