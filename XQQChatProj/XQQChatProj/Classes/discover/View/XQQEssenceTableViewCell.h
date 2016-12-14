//
//  XQQEssenceTableViewCell.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XQQEssenceToobar.h"
#import "XQQEssenceModel.h"
#import "XQQEssenceFrameModel.h"
#import "XQQEssencePhotoView.h"
#import "XQQEssenceVideoView.h"
#import "XQQEssenceVoiceView.h"
#import "XQQCommentView.h"
#import <ZFPlayer.h>

@interface XQQEssenceTableViewCell : UITableViewCell

/** block */
@property (nonatomic, copy)  void(^block)(NSInteger,NSInteger);



/** 数据模型 */
@property(nonatomic, strong)  XQQEssenceModel  *  essenceModel;
/** frameModel */
@property(nonatomic, strong)  XQQEssenceFrameModel *  frameModel;

/** 顶部整体 */
@property(nonatomic, strong)  UIView       *  topView;
/** 头像 */
@property(nonatomic, strong)  UIImageView  *  iconImageView;
/** 名称 */
@property(nonatomic, strong)  UILabel      *  nameLabel;
/** 时间label */
@property(nonatomic, strong)  UILabel      *  timeLabel;
/** 右上角按钮 */
@property(nonatomic, strong)  UIButton     *  rightBtn;
/** 文字label */
@property(nonatomic, strong)  UILabel      *  centerTextLabel;


/** 图片的View */
@property(nonatomic, strong)  XQQEssencePhotoView  *  photoView;
/** 声音的View */
@property(nonatomic, strong)  XQQEssenceVoiceView  *  voiceView;
/** 视频的View */
@property(nonatomic, strong)  XQQEssenceVideoView  *  videoView;



/** 中间的图片 */
@property(nonatomic, strong)  UIImageView  *  centerImageView;
/** 是否为动态图 */
@property(nonatomic, strong)  UIImageView  *  leftGifImageView;
/**音频的图片*/
@property(nonatomic, strong)  UIImageView  *  voiceImageView;
/**视频的图片*/
@property(nonatomic, strong)  UIImageView  *  videoImageView;

/** 最热评论view */
@property(nonatomic, strong)  XQQCommentView       *  hotCommentView;

/** 底部工具条 */
@property(nonatomic, strong)  XQQEssenceToobar  *  bottomToobar;


/** cell的高度 */
@property(nonatomic, assign)  CGFloat   cellHeight;

/** 这个cell的indexPath */
@property(nonatomic, strong)  NSIndexPath  *  cellIndexPath;
/** cell所属的tableView */
@property(nonatomic, strong)  UITableView  *  tableView;

/** 这个cell是否正在播放 */
@property(nonatomic, assign)  BOOL   isPlaying;


+ (instancetype)cellWithTabelView:(UITableView*)tabelView WithIndexPath:(NSIndexPath*)indexPath;
/**移除播放器*/
- (void)removePlayerWithCell:(XQQEssenceTableViewCell*)cell;

@end
