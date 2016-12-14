//
//  XQQCommentModel.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQQCommentUserModel.h"
@interface XQQCommentModel : NSObject
/** 评论内容 */
@property (nonatomic, copy)  NSString  *  content;
/** 评论时间 */
@property (nonatomic, copy)  NSString  *  ctime;
/**  评论的用户模型*/
@property (nonatomic, strong)  XQQCommentUserModel  *  userModel;

@end
