//
//  XQQCommentUserModel.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQQCommentUserModel : NSObject
/** 好友名字 */
@property (nonatomic, copy)  NSString  *  username;
/** 好友的个人主页 */
@property (nonatomic, copy)  NSString  *  personal_page;
/** 好友头像 */
@property (nonatomic, copy)  NSString  *  profile_image;
/** 好友性别 */
@property (nonatomic, copy)  NSString  *  sex;
@end
