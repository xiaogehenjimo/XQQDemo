//
//  XQQEssenceModel.h
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XQQCommentModel.h"
@interface XQQEssenceModel : NSObject
/***/
@property(nonatomic,copy) NSString *  bimageuri;
/**帖子的收藏量*/
@property(nonatomic,copy) NSString *  bookmark;
/***/
@property(nonatomic,copy) NSString *  cache_version;
/**踩数量*/
@property(nonatomic,assign) NSInteger   cai;
/**视频加载时候的静态显示的图片地址*/
@property(nonatomic,copy) NSString *  cdn_img;
/**评论数量*/
@property(nonatomic,assign) NSInteger   comment;
/***/
@property(nonatomic,copy) NSString *  create_time;
/**帖子审核通过的时间*/
@property(nonatomic,copy) NSString *  created_at;
/**顶数量*/
@property(nonatomic,assign) NSInteger   ding;
/**帖子的收藏量*/
@property(nonatomic,copy) NSString *  favourite;
/**踩的数量*/
@property(nonatomic,assign) NSInteger   hate;
/**图片或视频等其他的内容的高度*/
@property(nonatomic,copy) NSString *  height;
/**帖子id*/
@property(nonatomic,copy) NSString *  ID;
/**显示在页面中的视频图片的url*/
@property(nonatomic,copy) NSString *  image0;
/**显示在页面中的视频图片的url*/
@property(nonatomic,copy) NSString *  image1;
/***/
@property(nonatomic,copy) NSString *  image2;
/**是否为gif动态图*/
@property(nonatomic,copy) NSString *  is_gif;
/**收藏量*/
@property(nonatomic,copy) NSString *  love;
/**用户的名字*/
@property(nonatomic,copy) NSString *  name;
/***/
@property(nonatomic,copy) NSString *  original_pid;
/**帖子通过的时间和created_at的参数时间一致*/
@property(nonatomic,copy) NSString *  passtime;
/**用户的头像*/
@property(nonatomic,copy) NSString *  profile_image;
/**转发分享数量*/
@property(nonatomic,assign) NSInteger   repost;
/**发帖人的昵称*/
@property(nonatomic,copy) NSString *  screen_name;
/***/
@property(nonatomic,copy) NSString *  status;
/***/
@property(nonatomic,copy) NSString *  t;
/**帖子的标签备注*/
@property(nonatomic,copy) NSString *  tag;
/**帖子的文字内容*/
@property(nonatomic,copy) NSString *  text;
/**标签的id,如：微视频的id为55*/
@property(nonatomic,copy) NSString *  theme_id;
/**帖子的所属分类的标签名字*/
@property(nonatomic,copy) NSString *  theme_name;
/**一般为1*/
@property(nonatomic,copy) NSString *  theme_type;
/***/
@property(nonatomic, strong)  NSArray  *  themes;
/**最热评论*/
@property(nonatomic, strong)  NSArray<XQQCommentModel*>  *  cmtArr;
/**帖子的类型*/
@property(nonatomic,copy) NSString *  type;
/**发帖人的id*/
@property(nonatomic,copy) NSString *  user_id;
/**如果含有视频则该参数为视频的长度*/
@property(nonatomic,copy) NSString *  videotime;
/**视频播放的url地址*/
@property(nonatomic,copy) NSString *  videouri;
/**如果为音频则为音频的时长*/
@property(nonatomic,copy) NSString *  voicelength;
/**如果为音频类帖子，则返回值为音频的时长*/
@property(nonatomic,copy) NSString *  voicetime;
/**如果为音频，则为音频的播放地址*/
@property(nonatomic,copy) NSString *  voiceuri;
/**当分享到微信中的url链接*/
@property(nonatomic,copy) NSString *  weixin_url;
/**视频或图片类型帖子的宽度*/
@property(nonatomic,copy) NSString *  width;

@end
