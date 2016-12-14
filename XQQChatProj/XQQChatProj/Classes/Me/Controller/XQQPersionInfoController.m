//
//  XQQPersionInfoController.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/18.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQPersionInfoController.h"
#import "XQQPersionCell.h"
#define iconStr [NSString stringWithFormat:@"%@%@",@"icon",[XQQManager sharedManager].userName]
#define userNickName [NSString stringWithFormat:@"%@%@",@"userNickName",[XQQManager sharedManager].userName]


@interface XQQPersionInfoController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>
/**数据源*/
@property(nonatomic, strong)  NSMutableArray * dataArr;
/** 列表 */
@property(nonatomic, strong)  UITableView  *  myTableView;
@end

@implementation XQQPersionInfoController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[XQQUserInfoTool sharedManager] getMyInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetmyInfo:) name:XQQNoticPersonInfo object:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*获取到个人信息会走这个方法*/
- (void)didGetmyInfo:(NSNotification*)notic{
    NSArray * infoArr = (NSArray*)notic.object;
    BmobObject * obj = infoArr[0];
    NSString * iconURL = [obj objectForKey:@"iconURL"];
    NSString * nickName = [obj objectForKey:@"nickName"];
    if ([iconURL isEqualToString:@"1.jpg"]) {//未上传
        [XQQManager sharedManager].isUploadIcon = NO;
    }else{
        [XQQManager sharedManager].isUploadIcon = YES;
        //拿到上传成功的图片名
        //http://ogts0vmmj.bkt.clouddn.com/998.jpg
        NSArray * finallArr = [iconURL componentsSeparatedByString:@"/"];
        [XQQManager sharedManager].uploadIconName = finallArr.lastObject;
        [XQQManager sharedManager].iconURL = iconURL;
    }
    //更新本地数据库个人信息
    [[XQQDataManager sharedDataManager] updatePersonTable:@{@"userName":[XQQManager sharedManager].userName,@"imageURL":iconURL,@"nickName":nickName}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI{
    self.navigationItem.title = @"个人信息";
    

    
    [self.view addSubview:self.myTableView];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQQPersionCell * cell = [XQQPersionCell cellForTableView:tableView rowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        CGRect frame = cell.leftLabel.frame;
        frame.origin.y = 10;
        frame.size.height = 40;
        cell.leftLabel.frame = frame;
        cell.leftLabel.text = @"头像";
        cell.centerLabel.hidden = YES;
        //显示用户头像
        UIImage * iconImage = [XQQUtility unarchiveDataFromCache:iconStr].firstObject;
        NSString * iconURl = [XQQManager sharedManager].iconURL;
        if (iconURl) {
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURl]];
        }else if(iconImage){
            cell.iconImageView.image = iconImage;
        }else{
            cell.iconImageView.image = [UIImage imageNamed:@"7.jpg"];
        }
    }else if(indexPath.row == 1){
        cell.leftLabel.text = @"昵称";
        cell.iconImageView.hidden = YES;
        //显示用户昵称
        NSString * userNick = [XQQUtility unarchiveDataFromCache:userNickName].firstObject;
        cell.centerLabel.text = userNick ? userNick:@"暂未设置";
    }else{
        cell.leftLabel.text = @"账号";
        cell.iconImageView.hidden = YES;
        cell.centerLabel.text = [XQQManager sharedManager].userName;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {//点击了更换头像
        //弹actionSheet
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"更换头像" message:@"你是否要更换当前的头像?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController* imagePicker;
                imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate =self;
                imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
                imagePicker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * camAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:changeAction];
        [alert addAction:camAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{//昵称
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"设置新的昵称" message:@"请设置新的昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        return 60.0;
    }else{
        return 40.0;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else{
        UITextField * tf = [alertView textFieldAtIndex:0];
        [XQQUtility archiveData:@[tf.text] IntoCache:userNickName];
        [XQQManager sharedManager].nickName = tf.text;
        [[XQQUserInfoTool sharedManager] changeNickName:tf.text];
        [self.myTableView reloadData];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image !=nil) {
        //拿到图片  //展示到cel上
        [XQQUtility archiveData:@[image] IntoCache:iconStr];
        
        [self.myTableView reloadData];
        //上传头像到七牛服务器
        //先判断是否已经传了头像到七牛
        if ([XQQManager sharedManager].isUploadIcon) {
            //先删除图片
            [[XQQQIniuTool sharedManager] deleteImageWithFormat:[XQQManager sharedManager].uploadIconName success:^(NSURLSessionDataTask *task, id responseObject) {
                [[XQQQIniuTool sharedManager] sendIconToQiniu:image];
            } failBlock:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD showInfoWithStatus:@"网络错误"];
            }];
        }else{
            [[XQQQIniuTool sharedManager] sendIconToQiniu:image];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
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
