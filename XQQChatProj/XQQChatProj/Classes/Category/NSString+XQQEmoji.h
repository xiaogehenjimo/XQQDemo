//
//  NSString+XQQEmoji.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XQQEmoji)
/*将十六进制的编码转为emoji字符*/
+ (NSString *)emojiWithIntCode:(int)intCode;
/*将十六进制的编码转为emoji字符*/
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;
/*是否为emoji字符*/
- (BOOL)isEmoji;


/**
 *  普通文字 --> 属性文字
 *
 *  @return 属性文字
 */
- (NSAttributedString *)attributedText;


@end
