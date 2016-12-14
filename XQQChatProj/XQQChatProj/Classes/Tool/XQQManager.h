//
//  XQQManager.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQQManager : NSObject
/** 是否是推送 */
@property(nonatomic, assign)  BOOL   isPush;
/** 推送的字典 */
@property(nonatomic, strong)  NSDictionary  *  pushDict;
/** 是否上传了头像 */
@property (nonatomic, assign)    BOOL isUploadIcon;
/** 上传的图片名 */
@property (nonatomic, copy)  NSString  *  uploadIconName;
/** 用户名 */
@property (nonatomic, copy)  NSString  *  userName;
/** 昵称 */
@property (nonatomic, copy)  NSString  *  nickName;
/** 头像链接 */
@property (nonatomic, copy)  NSString  *  iconURL;
/** objectID */
@property (nonatomic, copy)  NSString  *  objectID;
/** 数据库的文件夹路径 */
@property (nonatomic, copy)  NSString  *  dbPath;
/** 用户的数据库地址 */
@property (nonatomic, copy)  NSString  *  userDBPath;
/** 好友表名 */
@property (nonatomic, copy)  NSString  *  frindTableName;
/** 个人信息表名 */
@property (nonatomic, copy)  NSString  *  personTableName;
/** 消息表名 */
@property (nonatomic, copy)  NSString  *  chatListTableName;
/** 是否是自动登录 */
@property(nonatomic, assign)  BOOL   isAutoLogin;
/** 播放器正在播放的indexPath */
@property(nonatomic, strong)  NSIndexPath  *  playingIndexPath;
+ (instancetype)sharedManager;

/*获取网络状态*/
- (NSString*)getNetStates;
/*获取当前屏幕显示的viewcontroller*/
- (UIViewController *)getCurrentVC;
/**获取maxtime*/
- (NSString*)getMaxtimeWithKey:(NSString*)key;
/**更新字典*/
- (void)updateInfoDict:(NSDictionary*)infoDict
                   key:(NSString*)key;

/*获取当前控制器的window*/
- (UIWindow*)getWindow;

@end
