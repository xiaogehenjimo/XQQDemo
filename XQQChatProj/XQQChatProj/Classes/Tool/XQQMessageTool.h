//
//  XQQMessageTool.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EaseMobSDKFull/EaseMob.h>
#import <AVFoundation/AVFoundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface XQQMessageTool : NSObject

+ (instancetype)sharedMessageTool;
/*建立代理连接*/
- (void)buildDelegateConnect;
/*移除代理连接*/
- (void)removeDelegateConnect;
/*添加视频语音通话代理*/
- (void)addCallDelegate;
/*创建文字消息*/
- (EMMessage*)createTextMessageWithFrindName:(NSString*)frindName
                                         Str:(NSString*)messageStr
                                 messageType:(EMMessageType)messageType;
/*创建图片消息*/
- (EMMessage*)createImageMessageWithFrindName:(NSString*)frindName
                                    sendImage:(UIImage*)sendImage
                                  messageType:(EMMessageType)messageType;
/*创建语音消息*/
- (EMMessage*)createVoiceMessage:(NSString *)recordPath
                        duration:(NSInteger)duration
                      friendName:(NSString*)friendName
                     messageType:(EMMessageType)messageType;
/*构建位置消息*/
- (EMMessage*)createLocationMessage:(NSString*)friendName
                      locationModel:(BMKPoiInfo*)locationModel
                        messageType:(EMMessageType)messageType;


/*解析消息*/
- (NSString*)analyseMessageWithMessage:(EMMessage*)message;


- (void)callOutWithChatter:(NSDictionary *)dict;
-(BOOL)canVideo;
- (BOOL)canRecord;

/* 时间的转换*/
- (NSString *)conversationTime:(long long)time;
- (NSString*)calculateTimeNewMessageTime:(long long)newTime
                                 oldTime:(long long)oldTime;
@end
