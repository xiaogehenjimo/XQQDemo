//
//  XQQScrollBtn.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XQQScrollBtn;
@protocol scrollBtnDidPress <NSObject>

- (void)scrollBtnDidPress:(XQQScrollBtn*)scrollBtn;

@end

@interface XQQScrollBtn : UIView

@property (nonatomic, weak)  id<scrollBtnDidPress> delegate;

- (void)setTitle:(NSString*)title;
- (void)setTitleColor:(UIColor*)color;
- (void)setBottomColor:(UIColor*)color;

@end
