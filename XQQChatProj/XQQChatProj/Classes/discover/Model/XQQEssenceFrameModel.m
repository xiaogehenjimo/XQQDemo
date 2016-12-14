//
//  XQQEssenceFrameModel.m
//  XQQChatProj
//
//  Created by XQQ on 2016/12/8.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQEssenceFrameModel.h"
#import "XQQEssenceModel.h"
#import "XQQEssenceFrameModel.h"

@implementation XQQEssenceFrameModel
- (void)setEssenceModel:(XQQEssenceModel *)essenceModel{
    _essenceModel = essenceModel;
    //左上角动态图的frame
    self.leftGifImageViewFrame = CGRectMake(0, 0, 30, 30);
    
    //头像
    CGFloat iconWH = 50;
    CGFloat iconX = cellBoderWidth;
    CGFloat iconH = cellBoderWidth;
    self.iconImageViewFrame = CGRectMake(iconX,iconH,iconWH, iconWH);
    
    //名称
    CGFloat nameX = CGRectGetMaxX(self.iconImageViewFrame) + cellBoderWidth;
    CGFloat nameY = cellBoderWidth;
    //CGFloat nameW = iphoneWidth - 4 * cellBoderWidth - self.iconImageViewFrame.size.width - 40;
    //CGFloat nameH = 30;
    CGSize nameSize = [self sizeWithText:essenceModel.name AndFont:cellNameFont];
    self.nameLabelFrame = (CGRect){{nameX,nameY},nameSize};
    //右侧的按钮
    CGFloat rightBtnX = iphoneWidth - cellBoderWidth - 40;
    CGFloat rightBtnY = nameY;
    CGFloat rightBtnW = 40;
    CGFloat rightBtnH = 40;
    self.rightBtnFrame = CGRectMake(rightBtnX, rightBtnY, rightBtnW, rightBtnH);
    //时间
    CGFloat timeLabelX = nameX;
    CGFloat timeLabelY = CGRectGetMaxY(self.nameLabelFrame) + cellBoderWidth;
    CGSize timeSize = [self sizeWithText:essenceModel.create_time AndFont:cellTimeFont];
    self.timeLabelFrame = (CGRect){{timeLabelX,timeLabelY},timeSize};
    
    //中间文字的frame
    
    CGFloat centerLabelX = cellBoderWidth;
    CGFloat centerLabelY = CGRectGetMaxY(self.timeLabelFrame) + cellBoderWidth;
    CGFloat maxW = iphoneWidth - 2 * centerLabelX;
    CGSize  centerLabelSize = [self sizeWithText:essenceModel.text AndFont:cellContentFont MaxW:maxW];
    self.centerTextLabelFrame = (CGRect){{centerLabelX,centerLabelY},centerLabelSize};
    //顶部的frame
    CGFloat topX = 0;
    CGFloat topY = 0;
    CGFloat topW = iphoneWidth;
    CGFloat topH = CGRectGetMaxY(self.centerTextLabelFrame) + cellBoderWidth;
    self.topViewFrame = CGRectMake(topX, topY, topW, topH);
    
    CGFloat toolbarY;
    //判断帖子的类型  1为全部 10为图片 29为段子 31为音频 41为视频
    NSString * typeStr = [NSString stringWithFormat:@"%@",essenceModel.type];
    if (![typeStr isEqualToString:@"29"]) { // 如果是图片\声音\视频帖子, 才需要计算中间内容的高度
        // 中间内容的高度 == 中间内容的宽度 * 图片的真实高度 / 图片的真实宽度
        CGFloat contentH = (iphoneWidth - cellBoderWidth) * [essenceModel.height floatValue] / [essenceModel.width floatValue];
        self.bigPicture = NO;
        if (contentH >= [UIScreen mainScreen].bounds.size.height) { // 超长图片
            // 将超长图片的高度变为200
            contentH = 200;
            self.bigPicture = YES;
        }
        
        CGRect centerFrame = CGRectMake(cellBoderWidth, CGRectGetMaxY(self.topViewFrame) + cellBoderWidth, maxW, contentH);
        if ([typeStr isEqualToString:@"10"]) {//图片
            self.photoViewFrame = centerFrame;
        }else if ([typeStr isEqualToString:@"31"]){//音频
            self.voiceViewFrame = centerFrame;
        }else if ([typeStr isEqualToString:@"41"]){//视频
            self.videoViewFrame = centerFrame;
        }
        toolbarY = CGRectGetMaxY(centerFrame) + cellBoderWidth;
    }else{
        toolbarY = CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
    }
    
    
    CGFloat comtHeight = 0;
    if (essenceModel.cmtArr.count) {
        XQQCommentView * comm = [[XQQCommentView alloc]init];
        
        comm.commentArr = essenceModel.cmtArr;
        comtHeight = comm.commentHeight;
    }
    
    
    
    //    if ([typeStr isEqualToString:@"10"]) {//图片
    //        CGFloat imageViewY= CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
    //        CGFloat imageViewX = cellBoderWidth;
    //        CGFloat imageViewW = iphoneWidth - 2* cellBoderWidth;
    //        CGFloat imageHeight = [essenceModel.height floatValue] > 220? 220 : [essenceModel.height floatValue];
    //        self.photoViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
    //       toolbarY = CGRectGetMaxY(self.photoViewFrame) + cellBoderWidth;
    //    }else if ([typeStr isEqualToString:@"41"]){//视频
    //        CGFloat imageViewY= CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
    //        CGFloat imageViewX = cellBoderWidth;
    //        CGFloat imageViewW = iphoneWidth - 2* cellBoderWidth;
    //        CGFloat imageHeight = [essenceModel.height floatValue] > 220? 220 : [essenceModel.height floatValue];
    //        self.videoViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
    //        toolbarY = CGRectGetMaxY(self.videoViewFrame) + cellBoderWidth;
    //    }else if ([typeStr isEqualToString:@"31"]){//音频
    //        CGFloat imageViewY= CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
    //        CGFloat imageViewX = cellBoderWidth;
    //        CGFloat imageViewW = iphoneWidth - 2* cellBoderWidth;
    //        CGFloat imageHeight = [essenceModel.height floatValue] > 220? 220 : [essenceModel.height floatValue];
    //        self.voiceViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
    //        toolbarY = CGRectGetMaxY(self.voiceViewFrame) + cellBoderWidth;
    //    }else if ([typeStr isEqualToString:@"29"]){
    //        toolbarY = CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
    //    }
    
    //toolbar的frame
    CGFloat toobarX = 0;
    CGFloat toobarW = iphoneWidth;
    CGFloat toobarH = 40;
    self.toolBarFrame = CGRectMake(toobarX, toolbarY, toobarW, toobarH);
    //cell整体高度
    self.cellHeight = CGRectGetMaxY(self.toolBarFrame) + 2 * cellBoderWidth + comtHeight;
    
    
    
    
    //判断是否有图片
    
    //    if (essenceModel.image0) {//有图片 计算图片的frame
    //        CGFloat imageViewY= CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
    //        CGFloat imageViewX = cellBoderWidth;
    //        CGFloat imageViewW = iphoneWidth - 2* cellBoderWidth;
    //        CGFloat imageHeight = [essenceModel.height floatValue] > 220? 220 : [essenceModel.height floatValue];
    //        self.centerImageViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
    //        //中间视频的图片frame
    //        self.voiceImageViewFrame = CGRectMake((imageViewW -30)/2, (imageHeight -30)/2, 60, 60);
    //        //中间音频按钮的frame
    //        self.videoImageViewFrame = self.voiceImageViewFrame;
    //
    //
    //        self.photoViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
    //        self.voiceViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
    //        self.videoViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
    //
    //        toolbarY = CGRectGetMaxY(self.centerImageViewFrame) + cellBoderWidth;
    //    }else{
    //        toolbarY = CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
    //    }
    
    
    
    /*
     
     
     NSString * typeStr = [NSString stringWithFormat:@"%@",essenceModel.type];
     
     
     if ([typeStr isEqualToString:@"10"]) {//图片
     CGFloat imageViewY= CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
     CGFloat imageViewX = cellBoderWidth;
     CGFloat imageViewW = iphoneWidth - 2* cellBoderWidth;
     CGFloat imageHeight = [essenceModel.height floatValue] > 220? 220 : [essenceModel.height floatValue];
     self.centerImageViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
     toolbarY = CGRectGetMaxY(self.centerImageViewFrame) + cellBoderWidth;
     }else if ([typeStr isEqualToString:@"29"]){//段子
     toolbarY = CGRectGetMaxY(self.centerTextLabelFrame) + cellBoderWidth;
     }else if ([typeStr isEqualToString:@"31"]){//音频
     CGFloat imageViewY = CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
     //中间图片的frame
     CGFloat imageViewX = cellBoderWidth;
     CGFloat imageViewW = iphoneWidth - 2* cellBoderWidth;
     CGFloat imageHeight = [essenceModel.height floatValue] > 220? 220 : [essenceModel.height floatValue];
     self.centerImageViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
     toolbarY = CGRectGetMaxY(self.centerImageViewFrame) + cellBoderWidth;
     }else if ([typeStr isEqualToString:@"41"]){//视频
     //中间的文字的frame
     CGFloat imageViewY;
     imageViewY = CGRectGetMaxY(self.topViewFrame) + cellBoderWidth;
     //中间图片的frame
     CGFloat imageViewX = cellBoderWidth;
     CGFloat imageViewW = iphoneWidth - 2* cellBoderWidth;
     CGFloat imageHeight = [essenceModel.height floatValue] > 220? 220 : [essenceModel.height floatValue];
     self.centerImageViewFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageHeight);
     toolbarY = CGRectGetMaxY(self.centerImageViewFrame) + cellBoderWidth;
     }
     */
}


//计算文字
- (CGSize)sizeWithText:(NSString*)text AndFont:(UIFont*)font MaxW :(CGFloat)maxW{
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGSize)sizeWithText:(NSString*)text AndFont:(UIFont*)font {
    return [self sizeWithText:text AndFont:font MaxW:MAXFLOAT];
}

@end
