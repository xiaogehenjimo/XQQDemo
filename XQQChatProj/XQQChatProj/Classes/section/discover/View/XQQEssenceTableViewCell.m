//
//  XQQEssenceTableViewCell.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQEssenceTableViewCell.h"
#import "XQQNavigationController.h"
#import "MainViewController.h"
#import <MWPhotoBrowser.h>
#import "XQQDiscoverViewController.h"
@interface XQQEssenceTableViewCell ()<ZFPlayerDelegate,MWPhotoBrowserDelegate>

/** 播放器 */
@property(nonatomic, strong)  ZFPlayerView  *  playerView;

@end


@implementation XQQEssenceTableViewCell
+ (instancetype)cellWithTabelView:(UITableView*)tabelView WithIndexPath:(NSIndexPath*)indexPath{
    static NSString * ID = @"essence";
    XQQEssenceTableViewCell * cell = [tabelView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XQQEssenceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.isPlaying = NO;
        self.playerView = [ZFPlayerView sharedPlayerView];
        //注册监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vcViewDidChange) name:@"changeVC" object:nil];
        //初始化顶部
        [self initTopView];
        //底部的toobar
        [self setUpToolBar];
    }
    return self;
    
    
}

- (void)vcViewDidChange{
    if (self.isPlaying) {
        [self.playerView pause];
        [self.playerView resetPlayer];
        [self.playerView removeFromSuperview];
        self.videoView.videoImageView.hidden = NO;
        self.isPlaying = NO;
    }
}
/**初始化控件*/
- (void)initTopView{
    UIView * topView = [[UIView alloc]init];
    self.topView = topView;
    //topView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:topView];
    //头像
    UIImageView  *  iconImageView = [[UIImageView alloc]init];
    self.iconImageView = iconImageView;
    [topView addSubview:iconImageView];
    //名字
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel = nameLabel;
    [topView addSubview:nameLabel];
    //时间label
    UILabel * timeLabel = [[UILabel alloc]init];
    //timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel = timeLabel;
    [topView addSubview:timeLabel];
    //右侧按钮
    UIButton * rightBtn = [[UIButton alloc]init];
    [rightBtn setImage:[UIImage imageNamed:@"cellmorebtnnormal"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"cellmorebtnclick"] forState:UIControlStateHighlighted];
    //绑定点击事件
    [rightBtn addTarget:self action:@selector(rightBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    [topView addSubview:rightBtn];
    //中间文字的label
    UILabel * centerLabel = [[UILabel alloc]init];
    centerLabel.numberOfLines = 0;
    //centerLabel.backgroundColor = [UIColor yellowColor];
    centerLabel.font = [UIFont systemFontOfSize:16];
    self.centerTextLabel = centerLabel;
    [topView addSubview:centerLabel];
    self.photoView = [[XQQEssencePhotoView alloc]init];
    self.voiceView = [[XQQEssenceVoiceView alloc]init];
    self.voiceView.voiceDidPress = ^(){
    };
    self.videoView = [[XQQEssenceVideoView alloc]init];
    [self.contentView addSubview:self.photoView];
    [self.contentView addSubview:self.voiceView];
    [self.contentView addSubview:self.videoView];
    //添加评论按钮
    _hotCommentView = [[XQQCommentView alloc]init];
    [self.contentView addSubview:_hotCommentView];
}

- (void)setFrameModel:(XQQEssenceFrameModel *)frameModel{
    _frameModel = frameModel;
    //数据模型
    XQQEssenceModel * model = frameModel.essenceModel;
    //右侧的按钮
    self.rightBtn.frame = frameModel.rightBtnFrame;
    //头像
    self.iconImageView.frame = frameModel.iconImageViewFrame;
    //给圆角会卡顿
    //    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width * .5;
    //    self.iconImageView.layer.masksToBounds = YES;
    
    UIImage * placeHolder = [UIImage circleImage:@"defaultUserIcon"];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.profile_image] placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.iconImageView.image = [image circleImage];
        }
    }];
    //名字label
    self.nameLabel.frame = frameModel.nameLabelFrame;
    self.nameLabel.text = model.name;
    //时间label
    self.timeLabel.frame = frameModel.timeLabelFrame;
    self.timeLabel.text = model.created_at;
    //中间的文字
    self.centerTextLabel.frame = frameModel.centerTextLabelFrame;
    self.centerTextLabel.text = model.text;
    self.topView.frame = frameModel.topViewFrame;
    NSString * modelType = [NSString stringWithFormat:@"%@",model.type];//1为全部 10为图片 29为段子 31为音频 41为视频
    CGFloat commentY = 0;
    __weak typeof(self) weekSelf = self;
    if ([modelType isEqualToString:@"10"]) {//图片
        self.photoView.frame = frameModel.photoViewFrame;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.photoView.hidden = NO;
        self.photoView.btnDidPress = ^(){
            //查看大图  获取当前活动的控制器
            MainViewController * mainVC = (MainViewController*)[[XQQManager sharedManager] getWindow].rootViewController;
            XQQNavigationController * actVC = mainVC.selectedViewController;
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
            browser.zoomPhotosToFill = YES;
            [actVC pushViewController:browser animated:YES];
        };
        self.photoView.frameModel = frameModel;
        commentY = CGRectGetMaxY(self.photoView.frame) + cellBoderWidth;
    }else if ([modelType isEqualToString:@"29"]){//段子
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.photoView.hidden = YES;
        commentY = CGRectGetMaxY(self.topView.frame) + cellBoderWidth;
    }else if ([modelType isEqualToString:@"31"]){//音频
        self.voiceView.frame = frameModel.voiceViewFrame;
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
        self.photoView.hidden = YES;
        self.voiceView.essenceModel = model;
        commentY = CGRectGetMaxY(self.voiceView.frame) + cellBoderWidth;
    }else if ([modelType isEqualToString:@"41"]){//视频
        self.videoView.frame = frameModel.videoViewFrame;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.photoView.hidden = YES;
        self.videoView.essenceModel = model;
        commentY = CGRectGetMaxY(self.videoView.frame) + cellBoderWidth;
        self.videoView.videoDidPress = ^(UIView * view){
            //取出单例里面正在播放的indexPath
            NSIndexPath * playingIndexPath = [XQQManager sharedManager].playingIndexPath;
            //判断当前点击cell的indexPath  是否和单例里面记录的是同一个
            if (playingIndexPath != weekSelf.cellIndexPath) {//不是同一个
                //拿到单例里面indexPath对应的那个cell
                XQQEssenceTableViewCell * playingCell = [weekSelf.tableView cellForRowAtIndexPath:playingIndexPath];
                //移除播放器
                [weekSelf removePlayerWithCell:playingCell];
            }
            //记录播放的IndexPath
            [XQQManager sharedManager].playingIndexPath = weekSelf.cellIndexPath;
            [weekSelf addMoviePlayerWithView:view essenceModel:model essenceCell:weekSelf];
            //隐藏播放按钮
            weekSelf.videoView.videoImageView.hidden = YES;
            weekSelf.isPlaying = YES;
        };
    }
    if(model.cmtArr.count){//有评论
        self.hotCommentView.hidden = NO;
        _hotCommentView.commentArr = model.cmtArr;
        CGFloat commentX = cellBoderWidth;
        CGFloat commentW = iphoneWidth - 2 * cellBoderWidth;
        CGFloat commentH = _hotCommentView.commentHeight;
        self.hotCommentView.frame = CGRectMake(commentX, commentY, commentW, commentH);
        CGRect toolBarFrame = frameModel.toolBarFrame;
        toolBarFrame.origin.y = CGRectGetMaxY(self.hotCommentView.frame) + cellBoderWidth;
        self.bottomToobar.frame = toolBarFrame;
        self.bottomToobar.essenceModel = model;
    }else{
        self.hotCommentView.hidden = YES;
        //底部的toolBar
        self.bottomToobar.frame = frameModel.toolBarFrame;
        self.bottomToobar.essenceModel = model;
    }
}
/** 播放器返回按钮事件 */
- (void)zf_playerBackAction{
    //退出播放
    [self removePlayerWithCell:[self.tableView cellForRowAtIndexPath:[XQQManager sharedManager].playingIndexPath]];
}

/** 播放器下载视频 */
- (void)zf_playerDownload:(NSString *)url{
    NSLog(@"点击了下载视频");
}
/**移除播放器*/
- (void)removePlayerWithCell:(XQQEssenceTableViewCell*)cell{
    if (cell.isPlaying) {//这个cell正在播放
        [self.playerView pause];
        [self.playerView resetPlayer];
        [self.playerView removeFromSuperview];
        cell.videoView.videoImageView.hidden = NO;
        cell.isPlaying = NO;
    }
}

/**点击了播放按钮*/
- (void)addMoviePlayerWithView:(UIView*)view essenceModel:(XQQEssenceModel*)essenceModel essenceCell:(XQQEssenceTableViewCell*)essenceCell{
    self.playerView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    [essenceCell.contentView addSubview:self.playerView];
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    self.playerView.controlView = controlView;
    self.playerView.delegate = self;
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    self.playerView.hasDownload = NO;
    self.playerView.videoURL = [NSURL URLWithString:essenceModel.videouri];
    self.playerView.title = essenceModel.text;
    [self.playerView play];
    [self.playerView autoPlayTheVideo];
    self.isPlaying = YES;
}

/**
 *  初始化工具条
 */
- (void)setUpToolBar{
    XQQEssenceToobar  *  toolBar = [XQQEssenceToobar toolbar];
    self.bottomToobar = toolBar;
    toolBar.bottomButtonDidPress = ^(NSInteger btnTag){
        //工具条点击方法
        [self toolBarDidPress:btnTag];
    };
    [self.contentView addSubview:toolBar];
}
/**
 *  工具条点击方法
 */
- (void)toolBarDidPress:(NSInteger)btnTag{
    switch (btnTag) {
        case 10081:
        {//转发
            NSLog(@"赞");
        }
            break;
        case 10082:
        {//评论
            NSLog(@"踩");
        }
            break;
        case 10083:
        {//赞
            NSLog(@"转发");
        }
            break;
        case 10084:
        {//赞
            NSLog(@"评论");
        }
            break;
            
        default:
            break;
    }
}
- (void)rightBtnDidPress:(UIButton*)button{
    XQQLogFunc
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    NSString *path = self.frameModel.essenceModel.image0;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:path]) {
        // 设置图片浏览器中的图片对象 (本地获取的)
        return [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:path]];
    }else{
        // 设置图片浏览器中的图片对象 (使用网络请求)
        path = self.frameModel.essenceModel.image0;
        return [MWPhoto photoWithURL:[NSURL URLWithString:path]];
    }
}
@end
