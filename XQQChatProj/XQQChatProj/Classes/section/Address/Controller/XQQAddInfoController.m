//
//  XQQAddInfoController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/28.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQAddInfoController.h"
#import "XQQDetailCell.h"
#import "XQQSendAddInfoController.h"
#import "XQQNavigationController.h"

@interface XQQAddInfoController ()<UITableViewDelegate,UITableViewDataSource,EMCallManagerDelegate>
/*列表*/
@property(nonatomic, strong)  UITableView * myTableView;
/** 数据 */
@property(nonatomic, strong)  NSMutableArray  *  dataArr;
/** footView */
@property(nonatomic, strong)  UIView  *  footView;
/** 发消息按钮 */
@property(nonatomic, strong)  UIButton  *  addBtn;

@end

@implementation XQQAddInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
/*创建UI*/
- (void)initUI{
    self.navigationItem.title = @"用户资料";
    
    NSArray * tmpArr = @[@[@{@"name":_friendModel.userName,@"nickName":_friendModel.nickName,@"iconURL":_friendModel.iconImgaeURL}],//个人信息 以后可以增加
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
    [self.view showToastWithStr:@"点击添加好友哦~"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - activity

/*添加好友点击了*/
- (void)addBtnDidPress:(UIButton*)button{
    XQQSendAddInfoController * sendVC = [[XQQSendAddInfoController alloc]init];
    sendVC.friendModel = self.friendModel;
    [self.navigationController pushViewController:sendVC animated:YES];
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
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(iphoneWidth/4, 10, iphoneWidth/2, 44)];
        _addBtn.layer.cornerRadius = 10.0;
        _addBtn.layer.masksToBounds = YES;//37  167  39
        
        _addBtn.backgroundColor = XQQColor(37, 167, 39);
        [_addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_footView addSubview:_addBtn];
        
        _footView.frame = CGRectMake(0, 0, iphoneWidth, CGRectGetMaxY(_addBtn.frame) + 10);
        _myTableView.tableFooterView = _footView;
    }
    return _myTableView;
}
@end
