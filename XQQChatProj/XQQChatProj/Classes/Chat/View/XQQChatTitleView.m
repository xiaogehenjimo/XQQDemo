//
//  XQQChatTitleView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatTitleView.h"

@interface XQQChatTitleView ()
/*昵称label*/
@property(nonatomic, strong)  UILabel  *  nickNameLabel;
/** 是否在线 */
@property(nonatomic, strong)  UILabel  *  statesLabel;

@end

@implementation XQQChatTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 0.7)];
       // _nickNameLabel.backgroundColor = [UIColor redColor];
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:19];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.textColor = [UIColor whiteColor];
        _statesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nickNameLabel.frame)+ 2, frame.size.width, frame.size.height * 0.3 -3)];
       // _statesLabel.backgroundColor = [UIColor redColor];
        _statesLabel.textAlignment = NSTextAlignmentCenter;
        _statesLabel.font = [UIFont systemFontOfSize:14];
        _statesLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nickNameLabel];
        [self addSubview:_statesLabel];
    }
    return self;
}

- (void)setInfoDict:(NSDictionary *)infoDict{
    _infoDict = infoDict;
    id classss = infoDict[@"model"];
    if (![classss isKindOfClass:[XQQFriendModel class]]) {//群聊
        EMGroup * chatGroup = infoDict[@"group"];
        _nickNameLabel.text = chatGroup.groupSubject;
        _statesLabel.text = [NSString stringWithFormat:@"%ld人在线",chatGroup.groupOnlineOccupantsCount];
    }else{//单聊
        XQQFriendModel * friendModel = infoDict[@"model"];
        NSString * nickName = [friendModel.nickName isEqualToString:@"暂未设置"] ? friendModel.userName:friendModel.nickName;
        NSString * states = friendModel.isOnline ? @"在线":@"离线";
        _nickNameLabel.text = nickName;
        _statesLabel.text = states;
    }
}

@end
