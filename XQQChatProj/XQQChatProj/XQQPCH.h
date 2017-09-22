//
//  XQQPCH.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#ifndef XQQPCH_h
#define XQQPCH_h
#ifdef __OBJC__

/**将数据写到桌面plist*/
#define XQQWriteToPlist(data,fileName) [data writeToFile:[NSString stringWithFormat:@"/Users/gl/Desktop/%@.plist",fileName] atomically:YES];

/*日志相关*/
#ifdef DEBUG
#define XQQLog(...)  NSLog(__VA_ARGS__)
#else
#define XQQLog(...)
#endif

#define XQQLogFunc XQQLog(@"%s", __func__);

/*颜色相关*/
#define XQQColorAlpa(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define XQQColor(r,g,b)         XQQColorAlpa((r),(g),(b),255)
#define XQQRandomColor          XQQColor(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))
#define XQQGrayColor(r)  XQQColor((r),(r),(r))
#define XQQBGColor       XQQGrayColor(214)
#define XQQSingleColor(r)  XQQColor((r),(r),(r))


#define iphoneWidth  [UIScreen mainScreen].bounds.size.width
#define iphoneHeight [UIScreen mainScreen].bounds.size.height

//版本号
//#define kSystem_Version [[[UIDevice currentDevice] systemVersion] floatValue]

#define kSystem_Version_Equal_To(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define kSystem_Version_Greater_Than(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define kSystem_Version_Greater_Than_Or_Equal_To(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kSystem_Version_Less_Than(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kSystem_Version_Less_Than_Or_Equal_To(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//地图搜索存储字段名
#define search_name @"searchName"
#define search_type @"searchType"
#define search_time @"searchTime"
//时间格式
#define xqq_timeFormat @"yyyy-MM-dd HH:mm:ss"



#define kDocumentsPath                      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
/*图片名字*/
#define XQQImageName(name)  [UIImage imageNamed:(name)]

//通知名类
#define XQQNoticPersonInfo @"getCurrentUserInfo"
#define XQQNoticFriendList @"getFriendInfo"
#define XQQNoticDidRecieveMessage @"didReceveMessageNotic"
#define XQQNoticGetFriendInfo @"getFriendInfo"
#define XQQNoticeRecieveRemoteNotice @"didReceiveRemoteNotification"

//设备判断
#define iPhone4         (iphoneWidth == 320.0f && iphoneHeight == 480.0f ? YES : NO)
#define iPhone5         (iphoneWidth == 320.0f && iphoneHeight == 568.0f ? YES : NO)
#define iPhone6         (iphoneWidth == 375.0f && iphoneHeight == 667.0f ? YES : NO)
#define iPhone6Plus     (iphoneWidth == 414.0f && iphoneHeight == 736.0f ? YES : NO)
#define iPhone4_5       (iphoneWidth == 320.0f && iphoneHeight == 1.0f ? YES : NO)

//链接
#define XQQCommonURL @"https://api.budejie.com/api/api_open.php"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <EaseMobSDKFull/EaseMob.h>
#import "XQQManager.h"
#import "UIView+XQQAdd.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <MWPhotoBrowser.h>
#import <MJExtension.h>
#import "XQQUtility.h"
#import "Toast+UIView.h"
#import "XQQAPIClient.h"
#import "UIBarButtonItem+XQQExtension.h"
#import "XQQToastTool.h"
#import "XQQDataManager.h"
#import "XQQMessageTool.h"
#import "Reachability.h"
#import <BmobSDK/Bmob.h>
#import "XQQQIniuTool.h"
#import "XQQUserInfoTool.h"
#import <SVProgressHUD.h>
#import "UIImage+XQQExtension.h"
#import "NSString+XQQEmoji.h"
#import "UITextView+XQQExtension.h"
#import "EMCDDeviceManager.h"
#import "XQQChatJumpTool.h"
#import "NSDate+XQQExtension.h"
#import "NSCalendar+XQQExtension.h"
#import "UIImage-Extensions.h"
#import "XQQRefreshNormalHeader.h"
#import "NSObject+XQQExtension.h"
#import "XQQBaiduMapTool.h"
#import "RegexKitLite.h"
#import "NSString+XQQSize.h"

#endif


#endif /* XQQPCH_h */
