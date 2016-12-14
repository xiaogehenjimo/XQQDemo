//
//  XQQCommentView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQCommentView.h"

#import "XQQCommentModel.h"
#import "XQQCommentUserModel.h"
@interface XQQCommentView ()

@end

@implementation XQQCommentView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XQQColor(246, 246, 246);
    }
    return self;
}

- (void)setCommentArr:(NSArray *)commentArr{
    _commentArr = commentArr;
    if (self.subviews) {
        [self removeAllSubviews];
    }
    for (NSInteger i = 0; i < commentArr.count; i ++) {
        XQQCommentModel * model = commentArr[i];
        //拿到评论的用户
        XQQCommentUserModel * userModel = model.userModel;
        NSString * userName = userModel.username;
        NSString * content = model.content;
        NSMutableAttributedString * tmpStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ :   %@",userName,content]];
        [tmpStr addAttribute:NSForegroundColorAttributeName value:XQQColor(4, 174, 199) range:NSMakeRange(0, userName.length + 1)];
        [tmpStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(userName.length + 1, content.length)];
        [tmpStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, tmpStr.length)];
        CGFloat maxW = iphoneWidth - 20 - 10;
        
        CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
        CGSize labelSize = [tmpStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
        CGFloat labelX = 5;
        CGFloat labelY = i * (labelSize.height) + 5;
        //创建label
        UILabel * label = [[UILabel alloc]initWithFrame:(CGRect){{labelX,labelY},labelSize}];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 0;
        label.attributedText = tmpStr;
        [self addSubview:label];
    }
    _commentHeight = CGRectGetMaxY(self.subviews.lastObject.frame) + 5;
}

@end
