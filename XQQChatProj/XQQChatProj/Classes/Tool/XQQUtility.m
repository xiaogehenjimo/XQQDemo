//
//  XQQUtility.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/14.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQUtility.h"
#import <CoreText/CoreText.h>
#define	kNetworkTestAddress @"www.cxc108.com"  // 测试网络是否畅通的地址
@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end

@implementation XQQUtility
static dispatch_queue_t queue;
//序列化写入缓存
+ (void)archiveData:(NSArray *)array IntoCache:(NSString *)path
{
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    
    myPath = [myPath stringByAppendingPathComponent:path];
    if(![[NSFileManager defaultManager] fileExistsAtPath:myPath])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager ];
        [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
        [[NSFileManager defaultManager] createFileAtPath:myPath contents:nil attributes:nil];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.liepin.archive", NULL);
    });
    
    dispatch_sync(queue, ^{
        if(![data writeToFile:myPath atomically:YES])
        {
            
        }
    });
    //dispatch_release(queue);
}

+ (NSArray *)unarchiveDataFromCache:(NSString *)path
{
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    NSData *fData       = nil;
    
    myPath = [myPath stringByAppendingPathComponent:path];
    if([[NSFileManager defaultManager] fileExistsAtPath:myPath])
    {
        fData = [NSData dataWithContentsOfFile:myPath];
    }
    else
    {
    }
    if (fData == nil ) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:fData];
}

+ (void)deleteArchiveDataWithPath:(NSString *)path
{
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    NSError *err        = nil;
    
    myPath = [myPath stringByAppendingPathComponent:path];
    
    [[NSFileManager defaultManager] removeItemAtPath:myPath error:&err];
}

//+ (NSString *)hzTransferToPinYin:(NSString * )hanzi
//{
//    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
//    [outputFormat setToneType:ToneTypeWithoutTone];
//    [outputFormat setVCharType:VCharTypeWithV];
//    [outputFormat setCaseType:CaseTypeLowercase];
//    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:hanzi withHanyuPinyinOutputFormat:outputFormat withNSString:@"^"];
//    return outputPinyin;
//
//    NSMutableString *ms = [[NSMutableString alloc] initWithString:hanzi];
//    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO))
//    {
//
//    }
//    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO))
//    {
//
//    }
//
//    return ms;
//}

//字符串是否有效
+(BOOL)stringIsAvailable:(NSString *)string{
    if(string && [string isKindOfClass:[NSString class]] && [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0){
        return YES;
    }
    return NO;
}

//数组是否有效
+(BOOL)arrayIsAvailable:(NSArray *)array{
    if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0){
        return YES;
    }
    return NO;
}

+ (BOOL)isStringPhoneNumberFormat:(NSString *)inputString
{
    @try {
        //        NSString *Regex =@"(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}";
        NSString *Regex =@"1[0-9]{10}";
        NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
        return [mobileTest evaluateWithObject:inputString];
    }
    @catch (NSException *exception) {
        return NO;
    }
}
+ (BOOL)isStringEmailFormat:(NSString *)inputString
{
    @try {
        NSString *Regex =@"^\\w+((-\\w+)|(\\.\\w+))*\\@[A-Za-z0-9]+((\\.|-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$";
        
        //        NSString *Regex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        //        NSString *Regex = @"^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
        
        //        NSString * Regex = @"^(\\S)+@(\\S])+((\\.\\S)+$";
        
        NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
        return [mobileTest evaluateWithObject:inputString];
    }
    @catch (NSException *exception) {
        return NO;
    }
}


+ (BOOL)isStringChinese:(NSString *)inputString
{
    @try {
        NSString *Regex =@"^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$";
        NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
        return [mobileTest evaluateWithObject:inputString];
    }
    @catch (NSException *exception) {
        return NO;
    }
}



+ (NSString *)decryptUseDESLarge:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    
    char *characters = malloc(cipherText.length / 2);
    for(NSUInteger i = 0; i < cipherText.length; i = i + 2)
    {
        NSString *subString = [cipherText substringWithRange:NSMakeRange(i, 2)];
        
        unsigned result = 0;
        NSScanner *scanner = [NSScanner scannerWithString:[@"#" stringByAppendingString:subString]];
        
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&result];
        
        characters[i / 2] = (char)result;
    }
    
    NSData *cipherdata = [NSData dataWithBytes:characters length:cipherText.length / 2];
    free(characters);
    
    unsigned char buffer[4096];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes],
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 4096,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

+ (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    
    char *characters = malloc(cipherText.length / 2);
    for(NSUInteger i = 0; i < cipherText.length; i = i + 2)
    {
        NSString *subString = [cipherText substringWithRange:NSMakeRange(i, 2)];
        
        unsigned result = 0;
        NSScanner *scanner = [NSScanner scannerWithString:[@"#" stringByAppendingString:subString]];
        
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&result];
        
        characters[i / 2] = (char)result;
    }
    
    NSData *cipherdata = [NSData dataWithBytes:characters length:cipherText.length / 2];
    free(characters);
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes],
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [textData length];
    //之后需要修改
    unsigned char *buffer = calloc(16384, sizeof(char));
    //    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes],
                                          [textData bytes], dataLength,
                                          buffer, 16384,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        const char *arr = [data bytes];
        
        NSMutableString *mutableString = [NSMutableString string];
        
        for(NSUInteger i = 0; i < [data length]; i++)
        {
            int j = arr[i];
            
            if(j < 0)
            {
                j += 256;
            }
            
            //            if(j < 16)
            //            {
            //                characters[2 * i] = '0';
            //                characters[2 * i + 1] = encodingTable[j & 15];
            //            }
            //            else
            //            {
            //                characters[2 * i] = encodingTable[(j >> 4) & 15];
            //                characters[2 * i + 1] = encodingTable[j & 15];
            //            }
            
            [mutableString appendFormat:@"%02x", j];
        }
        
        ciphertext = mutableString;//[NSString stringWithUTF8String:characters];
    }
    else
    {
        
    }
    
    free(buffer);
    
    return ciphertext;
}


//职位浏览记录
+ (void)addJobLookRecordWithJob:(NSNumber *)jobId
{
    NSMutableArray *jobList = [NSMutableArray arrayWithArray:[XQQUtility unarchiveDataFromCache:@"JobRecordList"]];
    BOOL exist = NO;
    for(NSNumber *lookJobId in jobList)
    {
        if([jobId integerValue] == [lookJobId integerValue])
        {
            exist = YES;
            break;
        }
    }
    if(!exist)
    {
        [jobList addObject:jobId];
    }
    [XQQUtility archiveData:jobList IntoCache:@"JobRecordList"];
}

+ (BOOL)whetherJobLookedWithJob:(NSNumber *)jobId
{
    NSMutableArray *jobList = [NSMutableArray arrayWithArray:[XQQUtility unarchiveDataFromCache:@"JobRecordList"]];
    BOOL exist = NO;
    for(NSNumber *lookJobId in jobList)
    {
        if([jobId integerValue] == [lookJobId integerValue])
        {
            exist = YES;
            break;
        }
    }
    
    return exist;
}

+ (CGSize)getTextHeightWithText:(NSString *)text
                           font:(UIFont *)font
                           size:(CGSize)size
{
    
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    
    return rect.size;
    if(text == nil || [text isEqualToString:@""])
    {
        return CGSizeZero;
    }
    
    CGFloat height = [XQQUtility heightStringWithEmojis:text fontType:font ForWidth:size.width];
    return CGSizeMake(rect.size.width, MAX(height, rect.size.height));
    
}

+ (CGSize)getTextHeightWithText:(NSString *)text
                           font:(UIFont *)font
                           size:(CGSize)size
                      lineSpace:(NSInteger)lineSpace
{
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutableDictionary setObject:font forKey:NSFontAttributeName];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpace];
    [mutableDictionary setObject:style forKey:NSParagraphStyleAttributeName];
    
    CGRect rect = [text boundingRectWithSize:size
                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                  attributes:mutableDictionary
                                     context:nil];
    return rect.size;
    
}

+ (CGSize)getTextHeightWithText:(NSString *)text
                           font:(UIFont *)font
                  lineBreakMode:(NSLineBreakMode)lineBreakMode
                           size:(CGSize)size
{
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode=lineBreakMode;
    CGRect rect = [text boundingRectWithSize:size
                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                  attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style}
                                     context:nil];
    
    if(text == nil || [text isEqualToString:@""])
    {
        return CGSizeZero;
    }
    
    CGFloat height = [XQQUtility heightStringWithEmojis:text fontType:font ForWidth:size.width];
    return CGSizeMake(rect.size.width, MAX(height, rect.size.height));
    
    
}

+ (CGSize)getTextHeightWithAttributedText:(NSAttributedString *)attributedString
                                     size:(CGSize)size
                            numberOfLines:(NSUInteger)numberOfLines
{
    if (!attributedString) {
        return CGSizeZero;
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    
    //calheight
    CFRange rangeToSize = CFRangeMake(0, (CFIndex)[attributedString length]);
    CGSize constraints = CGSizeMake(size.width, 100000);
    
    if (numberOfLines == 1) {
        // If there is one line, the size that fits is the full width of the line
        constraints = CGSizeMake(100000, 100000);
    } else if (numberOfLines > 0) {
        // If the line count of the label more than 1, limit the range to size to the number of lines that have been set
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, constraints.width, 100000));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);
        
        if (CFArrayGetCount(lines) > 0) {
            NSInteger lastVisibleLineIndex = MIN((CFIndex)numberOfLines, CFArrayGetCount(lines)) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
            
            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            rangeToSize = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }
        
        CFRelease(frame);
        CFRelease(path);
    }
    
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, NULL, constraints, NULL);
    
    CGSize calculatedSize=CGSizeMake(suggestedSize.width,suggestedSize.height);
    //
    
    CFRelease(framesetter);
    
    return calculatedSize;
}

+ (CGFloat)heightStringWithEmojis:(NSString*)str fontType:(UIFont *)uiFont ForWidth:(CGFloat)width {
    
    // Get text
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef) str );
    CFIndex stringLength = CFStringGetLength((CFStringRef) attrString);
    
    // Change font
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) uiFont.fontName, uiFont.pointSize, NULL);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, stringLength), kCTFontAttributeName, ctFont);
    
    // Calc the size
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRange fitRange;
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), &fitRange);
    
    CFRelease(ctFont);
    CFRelease(framesetter);
    CFRelease(attrString);
    
    return frameSize.height;
    
}


+ (NSString *)DateWithString:(NSTimeInterval)messageDate
{
    NSString *dateStr = nil;
    if (messageDate == 0) {
        return nil;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:messageDate/1000];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    dateStr = [dateFormatter stringFromDate:date];
    
    if ([currentDateStr isEqualToString:dateStr]) {
        [dateFormatter setDateFormat:@"HH:mm"];
        dateStr = [dateFormatter stringFromDate:date];
    }else
    {
        if (dateStr.length > 4) {
            if ([[dateStr substringWithRange:NSMakeRange(0, 4)] isEqualToString:[currentDateStr substringWithRange:NSMakeRange(0, 4)]]) {
                [dateFormatter setDateFormat:@"MM-dd"];
                dateStr = [dateFormatter stringFromDate:date];
            }else
            {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:date];
            }
        }
    }
    return dateStr;
}


+ (NSString *)LaunchImageName{
    CGSize viewSize = [[[[UIApplication sharedApplication] delegate] window] bounds].size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return launchImage;
}

+ (void)showLaunchImageNameInView:(UIView *)view{
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[XQQUtility LaunchImageName]]];
    
    launchView.frame = view.bounds;
    
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:launchView];
    
    [UIView animateWithDuration:12.0f
     
                          delay:0.0f
     
                        options:UIViewAnimationOptionBeginFromCurrentState
     
                     animations:^{
                         
                         launchView.alpha = 0.0f;
                         
                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         
                     }
     
                     completion:^(BOOL finished) {
                         
                         [launchView removeFromSuperview];
                         
                     }];
}

+ (NSString *)dateWithString:(NSTimeInterval)messageDate dateFormat:(NSString *)dateFormat
{
    
    if (messageDate == 0) {
        return nil;
    }
    //@"YYYY-MM-dd HH:mm"
    if (!dateFormat) {
        dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSLog(@"%f",[[NSDate date] timeIntervalSince1970]);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:messageDate/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateStr = nil;
    dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//+ (int)CheckNetworkStatus
//{
//    Reachability *r = [Reachability reachabilityWithHostName:kNetworkTestAddress];
//    NetworkStatus netStatus = [r currentReachabilityStatus];
//    return netStatus;
//}

+ (BOOL)verifyIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}


@end
