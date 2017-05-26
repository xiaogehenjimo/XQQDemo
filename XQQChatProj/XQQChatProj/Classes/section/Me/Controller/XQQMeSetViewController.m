//
//  XQQMeSetViewController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQMeSetViewController.h"
#import "AppDelegate.h"
@interface XQQMeSetViewController ()<UITableViewDelegate,UITableViewDataSource>
/**数据源*/
@property(nonatomic, strong)  NSMutableArray * dataArr;
/** 列表 */
@property(nonatomic, strong)  UITableView  *  myTableView;
/** 自动登录的开关 */
@property(nonatomic, strong)  UISwitch  *  autoSwitch;
@end

@implementation XQQMeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.myTableView];
    
    NSArray * tmpArr = @[@[@"自动登录"],
                         @[@"退出登录"]];
    [self.dataArr setArray:tmpArr];
}

/*开关点击了*/
- (void)switchDidChange:(UISwitch*)mySwitch{
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:mySwitch.isOn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = self.dataArr[section];
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * meSetCellID = @"setCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:meSetCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:meSetCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //右侧放置开关
            cell.accessoryType = UITableViewCellAccessoryNone;
            _autoSwitch = [[UISwitch alloc]init];
            if ([XQQManager sharedManager].isAutoLogin) {
                [_autoSwitch setOn:YES];
            }else{
               [_autoSwitch setOn:NO];
            }
            
            [_autoSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = _autoSwitch;
        }
    }
    
    if (indexPath.section == 3) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //退出登录
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (!error) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示!" message:@"退出当前账号?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    [delegate toLoginVC];
                    [self.navigationController popViewControllerAnimated:YES];
                    //更新用户在线状态
                    [[XQQUserInfoTool sharedManager] changeMyStates:NO];
                    //清空本地保存的用户名
                    [XQQUtility archiveData:@[@""] IntoCache:@"userName"];
                }];
                UIAlertAction * cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [alert addAction:cancelAct];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }else{
                NSLog(@"退出失败:%@",error);
            }
        } onQueue:nil];
    }else{
    }
}


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
    }
    return _myTableView;
}


@end
