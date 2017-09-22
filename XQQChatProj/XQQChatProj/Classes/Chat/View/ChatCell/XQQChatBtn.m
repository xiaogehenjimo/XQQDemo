//
//  XQQChatBtn.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/24.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatBtn.h"
#import "YCXMenu.h"
#import "YCXMenuItem.h"
@interface XQQChatBtn ()


@end

@implementation XQQChatBtn

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        //添加长按手势
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(chatBtnLongPress:)];
        longPress.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

#pragma mark - activity
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
/** 聊天气泡长按手势 */
- (void)chatBtnLongPress:(UILongPressGestureRecognizer*)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        
//        [self becomeFirstResponder];
        
        UIMenuController*menu = [UIMenuController sharedMenuController];
        
        UIMenuItem*relay = [[UIMenuItem alloc]initWithTitle:@"Relay"action:@selector(relay)];
        
        UIMenuItem*upload = [[UIMenuItem alloc]initWithTitle:@"Upload"action:@selector(relay)];
        
        UIMenuItem*collect = [[UIMenuItem alloc]initWithTitle:@"Collect"action:@selector(relay)];
        
        UIMenuItem*more = [[UIMenuItem alloc]initWithTitle:@"More"action:@selector(relay)];
        
        menu.arrowDirection = UIMenuControllerArrowDown;
        
        [menu setMenuItems:@[relay, upload, collect, more]];
        
        [menu setTargetRect:CGRectMake(0, 0, 100, 40) inView:self];
        
        [menu update];
        
        [menu setMenuVisible:YES];
        
        if (_longPressBlock) {
            _longPressBlock(self);
        }
    }
}

- (void)relay{
    
}



//- (void)setImage:(UIImage *)image forState:(UIControlState)state{
//    UIImage * newImage = [self imageCompressForSize:image targetSize:self.xqq_size];
//    
//    
//}

-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)click:(XQQChatBtn *)btn{
   
    if (_block) {
        _block(btn);
    }
}

+ (instancetype)createXQQButton{
    
    return [XQQChatBtn buttonWithType:UIButtonTypeCustom];
}





@end
