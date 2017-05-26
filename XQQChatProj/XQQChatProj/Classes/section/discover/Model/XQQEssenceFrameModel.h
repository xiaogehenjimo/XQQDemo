//
//  XQQEssenceFrameModel.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XQQEssenceModel.h"
#import "XQQCommentView.h"
//昵称字体
#define cellNameFont [UIFont systemFontOfSize:15]
//时间
#define cellTimeFont [UIFont systemFontOfSize:12]
//来源字体
#define cellSourceFont [UIFont systemFontOfSize:12]
//正文字体
#define cellContentFont [UIFont systemFontOfSize:16]

//转发正文字体
#define cellRetweetContentFont [UIFont systemFontOfSize:14]
/**
 * cell边框宽度
 */
#define cellBoderWidth 10

@interface XQQEssenceFrameModel : NSObject
/**数据model*/
@property(nonatomic, strong)  XQQEssenceModel  *  essenceModel;

/** 顶部整体 */
@property(nonatomic, assign)  CGRect    topViewFrame;
/** 头像 */
@property(nonatomic, assign)  CGRect    iconImageViewFrame;
/** 名称 */
@property(nonatomic, assign)  CGRect    nameLabelFrame;
/** 时间label */
@property(nonatomic, assign)  CGRect    timeLabelFrame;
/** 右上角按钮 */
@property(nonatomic, assign)  CGRect    rightBtnFrame;



/** 文字label */
@property(nonatomic, assign)  CGRect    centerTextLabelFrame;


/**中间imageView的frame*/
@property(nonatomic, assign)  CGRect   centerImageViewFrame;
/**左上角动态图*/
@property(nonatomic, assign)  CGRect   leftGifImageViewFrame;

/**音频的frame*/
@property(nonatomic, assign)  CGRect   voiceImageViewFrame;
/**视频的frame*/
@property(nonatomic, assign)  CGRect   videoImageViewFrame;

/**底部toolbar*/
@property(nonatomic, assign)  CGRect   toolBarFrame;



/** 图片的ViewFrame */
@property(nonatomic, assign)  CGRect    photoViewFrame;
/** 声音的ViewFrame */
@property(nonatomic, assign)  CGRect    voiceViewFrame;
/** 视频的ViewFrame */
@property(nonatomic, assign)  CGRect    videoViewFrame;

/**评论的frame*/
@property(nonatomic, assign)  CGRect   commentFrame;

/**是否为大图*/
@property(nonatomic, assign)  BOOL   bigPicture;







/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel7;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel8;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel9;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel10;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel11;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel12;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel13;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel14;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel15;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel16;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel17;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel18;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel19;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel20;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel21;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel22;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel23;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel24;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel25;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel26;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel27;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel28;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel29;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel30;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel31;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel32;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel33;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel34;
/**控件的model初始化*/
@property(nonatomic, assign)  CGRect   frameModel35;


/** cell高度 */
@property(nonatomic, assign)  CGFloat   cellHeight;

@end
