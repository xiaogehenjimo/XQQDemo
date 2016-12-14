//
//  XQQConversationCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQConversationCell.h"

#define boardWidth 10
@interface XQQConversationCell ()

/*头像*/
@property(nonatomic, strong)  UIImageView * iconImageView;
/** 用户i名 */
@property(nonatomic, strong)  UILabel  *  userNameLabel;
/** 最后一条聊天信息 */
@property(nonatomic, strong)  UILabel  *  lastMessageLabel;
/** 时间label */
@property(nonatomic, strong)  UILabel  *  timeLabel;
/** 未读消息数 */
@property(nonatomic, strong)  UILabel  *  unReadCountLabel;
@end

@implementation XQQConversationCell

+ (instancetype)cellForTableView:(UITableView*)tableView
                  rowAtIndexPath:(NSIndexPath*)indexPath{
    static NSString * idStr = @"conversationCell";
    XQQConversationCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell) {
        cell = [[XQQConversationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}
//65
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(boardWidth, boardWidth, 45, 45)];
        _iconImageView.layer.cornerRadius = 6;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.image = [UIImage imageNamed:@"1.jpg"];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(iphoneWidth - boardWidth - 100, boardWidth, 100, (65 - 4 * boardWidth)/2)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"";
        //_timeLabel.backgroundColor = [UIColor redColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + boardWidth, boardWidth + 5, iphoneWidth - 4 * boardWidth - _iconImageView.frame.size.width - _timeLabel.frame.size.width, (65 - 4 * boardWidth)/2)];
        //_userNameLabel.backgroundColor = [UIColor redColor];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:18];
        _userNameLabel.text = @"";
        _lastMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLabel.frame.origin.x, CGRectGetMaxY(_userNameLabel.frame) + boardWidth, iphoneWidth - 4 * boardWidth - _iconImageView.frame.size.width - 30, (65 - 4 * boardWidth)/2)];
        _lastMessageLabel.text = @"";
        //_lastMessageLabel.backgroundColor = [UIColor redColor];
        _lastMessageLabel.font = [UIFont systemFontOfSize:13];
        _unReadCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lastMessageLabel.xqq_right + boardWidth, _timeLabel.xqq_bottom + 5, 20, 20)];
        _unReadCountLabel.textColor = [UIColor whiteColor];
        _unReadCountLabel.text = @"2";
        _unReadCountLabel.textAlignment = NSTextAlignmentCenter;
        _unReadCountLabel.font = [UIFont boldSystemFontOfSize:15];
        _unReadCountLabel.backgroundColor = [UIColor redColor];
        _unReadCountLabel.layer.cornerRadius = 10;
        _unReadCountLabel.layer.masksToBounds = YES;
        _unReadCountLabel.hidden = YES;
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_userNameLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_lastMessageLabel];
        [self.contentView addSubview:_unReadCountLabel];
    }
    return self;
}


- (void)setModel:(XQQConversationModel *)model{
    _model = model;
    
    EMConversation * chatConversation = model.chatConversation;
    if (chatConversation.conversationType == eConversationTypeGroupChat) {
        //群组
        EMGroup * group = [EMGroup groupWithId:chatConversation.chatter];
        _userNameLabel.text = group.groupSubject;
        _iconImageView.image = [UIImage imageNamed:@"ff_IconGroup"];
    }else{//单聊
        _userNameLabel.text = model.nickName;
        [model.iconURL isEqualToString:@"1.jpg"] ? _iconImageView.image = [UIImage imageNamed:@"1.jpg"] : [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconURL] placeholderImage:[UIImage imageNamed:@"q.jpg"]];
    }
    //获取会话的最后一条信息
    EMMessage * lastMessage = [chatConversation latestMessage];
    if (lastMessage) {
        //时间label
        _timeLabel.text = [[XQQMessageTool sharedMessageTool] conversationTime:lastMessage.timestamp];
    }else{
        _timeLabel.text = @"";
    }
    NSString * lastStr = [[XQQMessageTool sharedMessageTool] analyseMessageWithMessage:lastMessage];
    _lastMessageLabel.text = lastStr;
    //加载未读消息数
    NSUInteger unCount = [[EaseMob sharedInstance].chatManager unreadMessagesCountForConversation:chatConversation.chatter];
    _unReadCountLabel.text = [NSString stringWithFormat:@"%ld",unCount];
    _unReadCountLabel.hidden = unCount == 0;
}

@end
