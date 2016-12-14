//
//  XQQChatModel.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/16.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EaseMobSDKFull/EaseMob.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface XQQChatModel : NSObject
/*接收到的消息体*/
@property (nonatomic, strong) EMMessage * recodeMessage;
/** 这条会话 */
@property(nonatomic, strong)  EMConversation  *  conversation;
///** 聊天的 */
@property(nonatomic, strong)  XQQChatBtn  *  chatBtn;
/*当前聊天的好友信息*/
@property(nonatomic, strong)  XQQFriendModel  *  friendModel;
/*时间label*/
@property(nonatomic, strong)  UILabel     *  timeLabel;
/** 左头像 */
@property(nonatomic, strong)  XQQChatBtn  *  leftChatIcon;
/** 右头像 */
@property(nonatomic, strong)  XQQChatBtn  *  rightChatIcon;




/** frame */
@property(nonatomic, assign)  CGRect   btnFrame;
/** 中间消息的frame */
@property(nonatomic, assign)  CGSize   chatBtnSize;

/** <# class#> */
@property(nonatomic, assign)  CGFloat   cellHeight;



///** 消息类型 */
//@property (nonatomic, copy)  NSString  *  messageType;
///** 是否为本人发送 */
//@property(nonatomic, assign)  BOOL   isMine;
//
//#pragma mark - 文字消息
///** 文字消息内容 */
//@property (nonatomic, copy)  NSString  *  messageText;
//
//
//#pragma mark - 图片消息
//
///** 图片链接 */
//@property (nonatomic, copy)  NSString  *  picURL;
///** 下载的链接 */
//@property (nonatomic, copy)  NSString  *  downloadUrl;
///** 发送的图片 */
//@property(nonatomic, strong)  UIImage  *  sendImage;
///** 本地图片路径 */
//@property (nonatomic, copy)  NSURL  *  localImagePath;
///** 图片的宽 */
//@property(nonatomic, assign)  CGFloat   imageWidth;
///** 图片的高 */
//@property(nonatomic, assign)  CGFloat   imageHeight;





@end
