//
//  XQQLoginTextField.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQLoginTextField.h"
#import <objc/runtime.h>
static NSString * const placeholderKey = @"placeholderLabel.textColor";
@implementation XQQLoginTextField

//- (CGRect)textRectForBounds:(CGRect)bounds{
//    CGFloat x = 10;
//    CGFloat y = bounds.origin.y;
//    CGFloat w = bounds.size.width - 10;
//    CGFloat h = bounds.size.height;
//    return CGRectMake(x, y, w, h);
//}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width-250, bounds.size.height);
    return inset;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tintColor = [UIColor whiteColor];
        //    NSDictionary * attrDict = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        //    NSAttributedString * str = [[NSAttributedString alloc]initWithString:self.placeholder attributes:attrDict];
        //    self.attributedPlaceholder = str;
        /**打印出这个类的所有属性*/
        //[XQQRuntimeTool logAllPropertyWithClass:[UITextField class]];
        //改变颜色
        id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [self setValue:[UIColor whiteColor] forKeyPath:placeholderKey];
            //一次性通知
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }];
        id endObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [self setValue:[UIColor grayColor] forKeyPath:placeholderKey];
            //一次性通知
            [[NSNotificationCenter defaultCenter] removeObserver:endObserver];
        }];

    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tintColor = [UIColor whiteColor];
    //    NSDictionary * attrDict = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //    NSAttributedString * str = [[NSAttributedString alloc]initWithString:self.placeholder attributes:attrDict];
    //    self.attributedPlaceholder = str;
    /**打印出这个类的所有属性*/
    //[XQQRuntimeTool logAllPropertyWithClass:[UITextField class]];
    //改变颜色
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self setValue:[UIColor whiteColor] forKeyPath:placeholderKey];
        //一次性通知
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    id endObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self setValue:[UIColor grayColor] forKeyPath:placeholderKey];
        //一次性通知
        [[NSNotificationCenter defaultCenter] removeObserver:endObserver];
    }];
}
@end
