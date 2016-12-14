//
//  XQQCommentModel.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQCommentModel.h"

@implementation XQQCommentModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"user"]) {
        XQQCommentUserModel * userModel = [[XQQCommentUserModel alloc]init];
        [userModel setValuesForKeysWithDictionary:value];
        _userModel = userModel;
    }
}
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end
