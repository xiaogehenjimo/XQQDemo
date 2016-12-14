//
//  XQQFrindStatesTool.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/16.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQFrindStatesTool.h"

@implementation XQQFrindStatesTool




/*获取好友状态*/
+ (NSString*)getFrindStatesWithEMBuddy:(EMBuddy*)body{
//    eEMBuddyFollowState_NotFollowed = 0,    //双方不是好友
//    eEMBuddyFollowState_Followed,           //对方已接受好友请求.
//    eEMBuddyFollowState_BeFollowed,         //登录用户已接受了该用户的好友请求
//    eEMBuddyFollowState_FollowedBoth        //"登录用户"和"小伙伴"都互相在好友列表中
    NSString * states = @"";
    switch (body.followState) {
        case eEMBuddyFollowState_NotFollowed:
        {
         states = @"0";
        }
            break;
        case eEMBuddyFollowState_Followed:{
            states = @"1";
        }
            break;
        case eEMBuddyFollowState_BeFollowed:{
            states = @"2";
        }
            break;
        case eEMBuddyFollowState_FollowedBoth:{
            states = @"3";
        }
            break;
        default:
            states = @"";
            break;
    }
    return states;
}
@end
