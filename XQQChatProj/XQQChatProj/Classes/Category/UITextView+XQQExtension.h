//
//  UITextView+XQQExtension.h
//  XQQChatProj
//
//  Created by XQQ on 2016/11/25.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (XQQExtension)
- (void)insertAttributedText:(NSAttributedString *)text;
- (void)insertAttributedText:(NSAttributedString *)text
                settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock;
@end
