//
//  XQQSendAddInfoController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/28.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQSendAddInfoController.h"
#import "XQQFriendModel.h"

@interface XQQSendAddInfoController ()<UITextViewDelegate>
/** 输入框 */
@property(nonatomic, strong)  UITextView  *  sendTextView;
/** 下一步按钮 */
@property(nonatomic, strong)  UIButton  *  nextBtn;
/** 本人昵称 */
@property (nonatomic, copy)  NSString  *  myNickName;
/** isLoading */
@property(nonatomic, assign)  BOOL   isLoding;
@end

@implementation XQQSendAddInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}


- (void)nextBtnClicked:(UIButton*)button{
    NSString * sendStr = self.sendTextView.text;
    if (sendStr.length == 0 ) {
        sendStr = _myNickName;
    }
    if (_isLoding) {
        return;
    }
    _isLoding = YES;
    BOOL isSuc = [[EaseMob sharedInstance].chatManager addBuddy:self.friendModel.userName message:sendStr error:nil];
    if (isSuc) {
        [self.view showToastWithStr:@"发送成功"];
        [self.navigationController popViewControllerAnimated:YES];
        _isLoding = NO;
    }else{
        [self.view showToastWithStr:@"发送失败"];
        _isLoding = NO;
    }
}


- (void)initUI{
    self.navigationItem.title = @"添加好友";
    
    _sendTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 74, iphoneWidth - 20, 200)];
    
    _sendTextView.backgroundColor = XQQColor(243, 243, 243);
    
    _sendTextView.delegate = self;

    _sendTextView.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:_sendTextView];
    
    [[XQQUserInfoTool sharedManager] getMyInfoComplete:^(NSArray *array, NSError *error) {
        BmobObject * object = array[0];
        NSString * nickName = [NSString stringWithFormat:@"我是%@,想添加你为好友",[object objectForKey:@"nickName"]];
        _sendTextView.text = nickName;
        _myNickName = nickName;
    }];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _nextBtn.frame = CGRectMake((iphoneWidth - 100) * 0.5, _sendTextView.xqq_bottom + 30, 120, 44);
    
    _nextBtn.backgroundColor = XQQColor(37, 167, 39);
    
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:@"确定添加" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _nextBtn.layer.cornerRadius = 8.0f;
    _nextBtn.layer.masksToBounds = YES;
    [_nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
}

@end
