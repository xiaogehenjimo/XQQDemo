//
//  XQQDataManager.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/15.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQDataManager.h"
#import "XQQFrindStatesTool.h"
#import "XQQFriendModel.h"

@implementation XQQDataManager

+ (instancetype)sharedDataManager{
    static XQQDataManager * manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[XQQDataManager alloc]init];
    });
    return manager;
}

/*获取数据库*/
- (void)GetDB{
    NSString * docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString * newPath = [docStr stringByAppendingPathComponent:@"XQQDB"];
    NSString * filePath = [newPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[XQQManager sharedManager].userName]];
    //NSLog(@"数据库的地址是:--%@",filePath);
    self.db = [FMDatabase databaseWithPath:filePath];
}

/*创建数据库*/
- (void)createDataBaseWithUserName:(NSString*)userName{
    NSString * docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString * newPath = [docStr stringByAppendingPathComponent:@"XQQDB"];
    NSString * filePath = [newPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",userName]];
    
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            self.db = [FMDatabase databaseWithPath:filePath];
        } else {
//            self.db = [[NSBundle mainBundle]pathForResource:userName ofType:@"sqlite"];
            XQQLog(@"已经存在此用户数据库");
            self.db = [FMDatabase databaseWithPath:filePath];
        }
    XQQLog(@"数据库地址:----------%@",filePath);
    [XQQManager sharedManager].userDBPath = filePath;
}

#pragma mark - 个人信息表
/*创建个人信息表*/
- (void)createPersonInfoTableWithUserName:(NSString*)userName{
    if ([self.db open]) {
        //判断是否为数字
        NSString * newStr = @"";
        if ([self isPureInt:userName]) {//全是数字
            newStr = [NSString stringWithFormat:@"XQQ%@PersonInfo",userName];
        }else{
            newStr = [NSString stringWithFormat:@"%@PersonInfo",userName];
        }
        NSString * createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (userName text  PRIMARY KEY NOT NULL,iconImageURL text ,nickName text);",newStr];
        
        BOOL result = [self.db executeUpdate:createStr];
        if (result) {
            XQQLog(@"创建个人信息表成功");
            [XQQManager sharedManager].personTableName = newStr;
        }else{
            XQQLog(@"创建个人信息表失败");
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
}

/*查看个人信息*/
- (NSArray*)searchCurrentPensonInfo{
    [self GetDB];
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.db open]) {
        NSString * tableName = [self getPersonTableName];
        NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *set = [self.db executeQuery:sqlStr];
        while ([set next]) {
            NSMutableDictionary * infoDict = [NSMutableDictionary dictionary];
            //infoDict[@"userName"] = [set stringForColumn:@"userName"];
            infoDict[@"imageURL"] = [set stringForColumn:@"iconImageURL"];
            //infoDict[@"nickName"] = [set stringForColumn:@"nickName"];
            [arr addObject:infoDict];
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
    return arr;
}

/*更新个人信息表*/
- (void)updatePersonTable:(NSDictionary*)infoDict{
    [self GetDB];
    //用户名
    NSString * userName = infoDict[@"userName"];
    //图片地址
    NSString * imageURL = infoDict[@"imageURL"];
    //昵称
    NSString * nickName = infoDict[@"nickName"];
    //获取表名
    NSString * tableName = [self getPersonTableName];
    NSString * sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET iconImageURL = ?,nickName = ? WHERE userName = ?",tableName];
    if ([self.db open]){
        BOOL result = [self.db executeUpdate:sqlStr,
                       imageURL,nickName,userName];
        if (result){
            XQQLog(@"修改个人信息成功");
        }else{
            XQQLog(@"修改个人信息失败");
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
}

#pragma mark - 聊天记录表
/*创建聊天表*/
- (void)createTableWithStr:(NSString*)userName{
    if ([self.db open]) {
        //frindName messageType messageID messageFrom messageTo isGroup messageBodyType isMin
        //判断是否为数字
        NSString * newStr = @"";
        if ([self isPureInt:userName]) {//全是数字
            newStr = [NSString stringWithFormat:@"XQQ%@ChatList",userName];
        }else{
            newStr = [NSString stringWithFormat:@"%@ChatList",userName];
        }
        NSString * createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,frindName text ,messageType text ,messageID text NOT NULL,messageFrom text ,messageTo text ,isGroup text ,groupSenderName text,messageBodyType text ,messageText text ,picURL text,VoiceLocalPath text,voiceDuration text,isMin text ,address text,latitude text,longitude text,moveRemoteImagePath text,videoPath text,videoDuration text);",newStr];
        BOOL result = [self.db executeUpdate:createStr];
        if (result) {
            XQQLog(@"创建聊天表成功");
            [XQQManager sharedManager].chatListTableName = newStr;
        }else{
            XQQLog(@"创建聊天表失败");
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
}

/*插入一条消息到数据库*/
- (void)insertMessage:(EMMessage*)message{
    [self GetDB];
    //好友名称
    NSString * friendName = @"";
    //消息类型
    NSString * messageType = @"";
    //消息ID
    NSString * messageID = message.messageId;
    //消息来自
    NSString * messageFrom = message.from;
    //消息发给谁
    NSString * messageTo = message.to;
    //是否是群聊
    //NSString * isGroup = @"";
    if (message.messageType == eMessageTypeChat) {
        messageType = @"eMessageTypeChat";
    }else if (message.messageType == eMessageTypeGroupChat){
        messageType = @"eMessageTypeGroupChat";
    }else if (message.messageType == eMessageTypeChatRoom){
        messageType = @"eMessageTypeChatRoom";
    }
    //群里面发送者名字
    NSString * groupSenderName = @"";
    //消息体类型
    NSString * messageBodyType = @"";
    //消息文字
    NSString * messageText = @"";
    //图片链接(缩略图链接)
    NSString * picURL = @"";
    //语音本地路径
    NSString * VoiceLocalPath = @"";
    //语音时长
    NSString * voiceDuration = @"";
    //地址
    NSString * address = @"";
    //精度
    NSString * longitude = @"";
    //维度
    NSString * latitude = @"";
    //图片远程路径
    NSString * moveRemoteImagePath = @"";
    //视频路径
    NSString * videoPath = @"";
    //视频时长
    NSString * videoDuration = @"";
    //判断类型
    //获取消息体
    id body = message.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {//文本类型
        messageBodyType = @"text";
        EMTextMessageBody * textBody = body;
        messageText = textBody.text;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){//语音
        messageBodyType = @"voice";
        //语音的消息体
        EMVoiceMessageBody * voiceBody = body;
        VoiceLocalPath = voiceBody.localPath;
        voiceDuration = [NSString stringWithFormat:@"%ld",voiceBody.duration];
    }else if ([body isKindOfClass:[EMImageMessageBody class]]){//图片
        messageBodyType = @"pic";
        //图片的消息体
        EMImageMessageBody * imageBody = body;
        picURL = imageBody.thumbnailRemotePath;
        moveRemoteImagePath = imageBody.thumbnailRemotePath;
    }else if ([body isKindOfClass:[EMVideoMessageBody class]]){//视频
        messageBodyType = @"video";
        //视频消息体
        EMVideoMessageBody * videoBody = body;
        videoPath = videoBody.localPath;
        videoDuration = [NSString stringWithFormat:@"%ld",videoBody.duration];
    }else if ([body isKindOfClass:[EMLocationMessageBody class]]){
        messageBodyType = @"location";
        //位置消息体
        EMLocationMessageBody * locationBody = body;
        address = locationBody.address;
        latitude = [NSString stringWithFormat:@"%.9f",locationBody.latitude];
        longitude = [NSString stringWithFormat:@"%.9f",locationBody.longitude];
    }
    //获取到消息表名
    NSString * messageTable = [self getChatListTableName];
    NSString * sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (frindName,messageType,messageID,messageFrom,messageTo,isGroup,messageBodyType,isMin,groupSenderName,messageText,picURL,VoiceLocalPath,voiceDuration,address,latitude,longitude,moveRemoteImagePath,videoPath,videoDuration) VALUES (?,?,?,?,?,?,?,?);",messageTable];
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:sqlStr, message.to, @"",@"",@"", @"",@"",@"",@""];
        if (result) {
            XQQLog(@"插入好友列表成功");
        }else{
            XQQLog(@"插入好友列表失败");
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
}

#pragma mark - 好友列表

/*删除一个好友*/
- (void)deleteFrinendWithFriendName:(NSString*)friendName{
    [self GetDB];
    NSString * tableName = [self getFriendTableName];
    NSString * sqlStr = [NSString stringWithFormat:@"delete from %@ where frindName = ?",tableName];
    
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:sqlStr,friendName];
        if (result) {
            XQQLog(@"删除好友成功成功");
        }else{
            XQQLog(@"删除好友失败");
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
}

/*数据库表中是否存在这个好友*/
- (BOOL)searchFriendWithUserName:(NSString*)userName{
    [self GetDB];
    BOOL isContent = NO;
    if ([self.db open]) {
        NSString * tableName = [self getFriendTableName];
        NSString * sqlStr = [NSString stringWithFormat:@"SELECT COUNT(frindName) AS countNum FROM %@ WHERE frindName = ?",tableName];
        FMResultSet *rs =[self.db executeQuery:sqlStr,userName];
        while ([rs next]) {
            NSInteger count = [rs intForColumn:@"countNum"];
            if (count > 0) {
                //存在
                XQQLog(@"存在");
                isContent = YES;
            }
            else
            {
                //不存在
                XQQLog(@"不存在");
                isContent = NO;
            }
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
    return isContent;
}

/*查找某个用户*/
- (NSDictionary*)searchFriend:(NSString*)userName{
    [self GetDB];
    NSMutableDictionary * infoDict = @{}.mutableCopy;
    /*表名字*/
    NSString * tableName = [self getFriendTableName];
    NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE frindName = ?",tableName];
    if ([_db open]) {
        FMResultSet * rs = [_db executeQuery:sqlStr,userName];
        while ([rs next]) {
            NSString * iconURL = [rs stringForColumn:@"iconImageURL"];
            NSString * nickName = [rs stringForColumn:@"nickName"];
            NSString * isOnline = [rs stringForColumn:@"followState"];
            infoDict[@"isOnline"] = isOnline;
            infoDict[@"iconURL"] = iconURL;
            infoDict[@"nickName"] = nickName;
        }
        [_db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
    return infoDict;
}

/*查找所有好友*/
- (NSArray*)searchAllFriend{
    [self GetDB];
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.db open]) {
        NSString * tableName = [self getFriendTableName];
        NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *set = [self.db executeQuery:sqlStr];
        while ([set next]) {
            NSString *name = [set stringForColumn:@"frindName"];
            NSString * iconURL = [set stringForColumn:@"iconImageURL"];
            NSString * nickName = [set stringForColumn:@"nickName"];
            XQQFriendModel * model = [[XQQFriendModel alloc]init];
            model.userName = name;
            model.iconImgaeURL = iconURL;
            model.nickName = nickName;
            [arr addObject:model];
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
    return arr;
}

/*更新某个好友信息*/
- (void)updateFriendInfo:(XQQFriendModel*)model{
    [self GetDB];
    /*好友表名*/
    NSString * tableName = [self getFriendTableName];
    NSString * nickName = model.nickName;
    NSString * userName = model.userName;
    NSString * iconURL = model.iconImgaeURL;
    NSString * isOnline = @"";
    if (model.isOnline) {
        isOnline = @"1";
    }else{
        isOnline = @"0";
    }
    NSString  * sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET iconImageURL = ?,followState = ?,nickName = ? WHERE frindName = ?",tableName];
    
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:sqlStr,
                       iconURL,isOnline,nickName,userName];
        if (result) {
            XQQLog(@"修改好友信息成功");
        }else{
            XQQLog(@"修改好友信息失败");
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
}

/*插入一个好友到数据库*/
- (void)insertNewFriendWithBody:(XQQFriendModel*)model{
    [self GetDB];
    /*如果有这个好友就不插入表*/
    if ([self searchFriendWithUserName:model.userName]) {
        return;
    }
    /*好友表名*/
    NSString * tableName = [self getFriendTableName];
    /*要插入的好友名称*/
    NSString * frindName = model.userName;
    /*好友头像*/
    NSString * imageURL = model.iconImgaeURL;
    /*好友状态*/
    NSString * frindState = @"";
    if (model.isOnline) {
        frindState = @"1";
    }else{
        frindState = @"0";
    }
    /*好友昵称*/
    NSString * nickName = model.nickName;
    NSString * sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (frindName,iconImageURL,followState,nickName) VALUES (?,?,?,?);",tableName];
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:sqlStr, frindName, imageURL,frindState,nickName];
        if (result) {
            XQQLog(@"插入%@成功",model.userName);
        }else{
            XQQLog(@"插入好友列表失败");
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
}


/*创建用户好友表*/
- (void)createUserFriendListWithUserName:(NSString*)userName{
    if ([self.db open]) {
        //判断是否为数字
        NSString * newStr = @"";
        if ([self isPureInt:userName]) {//全是数字
            newStr = [NSString stringWithFormat:@"XQQ%@FriendList",userName];
        }else{
            newStr = [NSString stringWithFormat:@"%@FriendList",userName];
        }
        NSString * createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,frindName text NOT NULL,iconImageURL text ,followState text,nickName text );",newStr];
        
        BOOL result = [self.db executeUpdate:createStr];
        if (result) {
            XQQLog(@"创建好友表成功");
            [XQQManager sharedManager].frindTableName = newStr;
        }else{
            XQQLog(@"创建好友表失败");
        }
        [self.db close];
    }else{
        XQQLog(@"数据库打开失败");
    }
}


/*获取历史记录表名字*/
- (NSString*)getChatListTableName{
    /*历史记录表名*/
    NSString * tableName = [XQQManager sharedManager].chatListTableName;
    /*当前登录的用户名*/
    NSString * userName = [XQQManager sharedManager].userName;
    if ([tableName isEqualToString:@""]||tableName == nil) {
        NSString * newStr = @"";
        if ([self isPureInt:userName]) {//全是数字
            newStr = [NSString stringWithFormat:@"XQQ%@ChatList",userName];
        }else{
            newStr = [NSString stringWithFormat:@"%@ChatList",userName];
        }
        return newStr;
    }else{
        return tableName;
    }
}
/*获取好友表名*/
- (NSString*)getFriendTableName{
    /*好友表名*/
    NSString * tableName = [XQQManager sharedManager].frindTableName;
    /*当前登录的用户名*/
    NSString * userName = [XQQManager sharedManager].userName;
    if ([tableName isEqualToString:@""]||tableName == nil) {//为空
        //判断是否为数字
        NSString * newStr = @"";
        if ([self isPureInt:userName]) {//全是数字
            newStr = [NSString stringWithFormat:@"XQQ%@FriendList",userName];
        }else{
            newStr = [NSString stringWithFormat:@"%@FriendList",userName];
        }
        return newStr;
    }else{
        return tableName;
    }
}
/*获取个人信息表名*/
- (NSString*)getPersonTableName{
    /*个人信息表名*/
    NSString * tableName = [XQQManager sharedManager].personTableName;
    /*当前登录的用户名*/
    NSString * userName = [XQQManager sharedManager].userName;
    if ([tableName isEqualToString:@""]||tableName == nil) {//为空
        //判断是否为数字
        NSString * newStr = @"";
        if ([self isPureInt:userName]) {//全是数字
            newStr = [NSString stringWithFormat:@"XQQ%@PersonInfo",userName];
        }else{
            newStr = [NSString stringWithFormat:@"%@PersonInfo",userName];
        }
        return newStr;
    }else{
        return tableName;
    }
}

/**判断用户名是否为数字*/
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
@end
