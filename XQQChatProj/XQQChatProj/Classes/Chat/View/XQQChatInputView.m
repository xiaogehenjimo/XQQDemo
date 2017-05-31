//
//  XQQChatInputView.m
//  XQQChatProj
//
//  Created by XQQ on 2016/11/23.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQChatInputView.h"
#import "XQQFaceView.h"
#import "XQQFaceModel.h"
#import "XQQVoiceAnimationView.h"
#import "XQQChatOtherView.h"
#import "XQQChatLocationController.h"
#import "XQQEmotionAttachment.h"

#define inputBoardWidth 5

@interface XQQChatInputView ()<UITextViewDelegate,otherBtnDidPressDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,sendLocationDelegate>
/*左侧按钮是否点击*/
@property(nonatomic, assign)  BOOL   leftBtnDidPress;
/** 右侧按钮是否点击 */
@property(nonatomic, assign)  BOOL   rightBtnDidPress;
/** 表情按钮 */
@property(nonatomic, strong)  XQQFaceView  *  faceView;
/** 表情按钮是否显示 */
@property(nonatomic, assign)  BOOL   isFaceViewShow;
/** 更多View */
@property(nonatomic, strong)  XQQChatOtherView  *  otherView;
/** 是否选择了表情或者其他 */
@property(nonatomic, assign)  BOOL   isKeyBoard;
@end

@implementation XQQChatInputView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        //添加表情按钮点击通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelFace:) name:@"face" object:nil];
        //表情删除按钮点击
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceDeleteBtnPress) name:@"KDeleteBtnPressNotificationName" object:nil];
        
        
        self.backgroundColor = XQQColor(220, 225, 225);
        //左侧按钮
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(inputBoardWidth, inputBoardWidth, 40, 40)];
        [self setBtnImage:@"ToolViewInputVoice" button:_leftBtn];
        [_leftBtn addTarget:self action:@selector(leftBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        //输入框
        _inputText = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftBtn.frame) + inputBoardWidth, inputBoardWidth +2.5, frame.size.width - 5*inputBoardWidth - 120, 35)];
        _inputText.delegate = self;
        _inputText.layer.cornerRadius = 8.0;
        _inputText.layer.masksToBounds = YES;
        _inputText.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _inputText.returnKeyType = UIReturnKeySend;
        _inputText.font = [UIFont systemFontOfSize:16];
        [self addSubview:_inputText];
        
        /*录制语音按钮*/
        _voiceBtn = [[UIButton alloc]initWithFrame:_inputText.frame];
        _voiceBtn.layer.cornerRadius = 8.0;
        _voiceBtn.layer.masksToBounds = YES;
        _voiceBtn.layer.borderWidth = 0.8;
        [_voiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _voiceBtn.layer.borderColor = XQQColor(170, 170, 170).CGColor;
        [_voiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_voiceBtn addTarget:self action:@selector(voiceBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        _voiceBtn.backgroundColor = XQQColor(230, 230, 230);
        //[self setBtnImage:@"VoiceInputSubLBtn" button:_voiceBtn];
        [_voiceBtn addTarget:self action:@selector(voiceBtnDidPress:) forControlEvents:UIControlEventTouchDown];
        _voiceBtn.hidden = YES;
        [self addSubview:_voiceBtn];
        
        
        //笑脸
        _faceBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_inputText.frame)+inputBoardWidth, inputBoardWidth, 40, 40)];
        [self setBtnImage:@"ToolViewEmotion" button:_faceBtn];
        [_faceBtn addTarget:self action:@selector(faceBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_faceBtn];
        //加号
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - inputBoardWidth - 40, inputBoardWidth, 40, 40)];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [_rightBtn addTarget:self action:@selector(rightBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        
        //创建表情view
        __weak typeof(self) weakSelf = self;
        _faceView = [[XQQFaceView alloc]initWithFrame:CGRectMake(0, iphoneHeight - 250, iphoneWidth, 250)];
        
        _faceView.bottomFaceTypeBtnPress = ^(NSInteger btnIndex){
            [weakSelf bottomFaceTypeBtnPress:btnIndex];
        };
        //表情下方的发送按钮点击
        _faceView.sendFaceBtnPressBlock = ^(){
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatInputViewDidEndEdit:)]) {
        
                NSString * outPutStr = [weakSelf fullText];
                
                [weakSelf.delegate chatInputViewDidEndEdit:outPutStr];
                
            }
            weakSelf.inputText.text = @"";
            
        };
        //更多View
        _otherView = [[XQQChatOtherView alloc]initWithFrame:_faceView.frame];
        _otherView.delegate = self;
        
        
    }
    return self;
}


#pragma mark - activity

/**
 *  选择表情
 *
 *  @param notice 传递的值
 */
- (void)didSelFace:(NSNotification*)notice{
    
    XQQFaceModel * model = notice.object;
    
    [self insertEmotion:model];
    
//    NSTextAttachment *  Attachment = [[NSTextAttachment alloc]init];
//    if ([model.png isEqualToString:@""]||model.png == nil) {
//        [self.inputText insertText:model.code.emoji];
//    }else{
//        Attachment.image = [UIImage imageNamed:model.png];
//        NSAttributedString * str = [NSAttributedString attributedStringWithAttachment:Attachment];
//        [self.inputText insertAttributedText:str];
//    }
}

/** 删除表情按钮点击 */
- (void)faceDeleteBtnPress{
    //删掉输入框中的表情
    
    [self.inputText deleteBackward];
    
}


/*表情种类按钮点击*/
- (void)bottomFaceTypeBtnPress:(NSInteger)btnTag{
    
}

/*录制语音按钮按下去*/
- (void)voiceBtnDidPress:(UIButton*)button{
    //播放动画
    UIViewController * delegateVC = (UIViewController*)self.delegate;
    [XQQVoiceAnimationView showAnimationWithView:delegateVC.view];
    
    
    //开始录音
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (!error) {
            //开始录音成功
            NSLog(@"开始录音成功");
        }else{
            NSLog(@"开始录音失败");
        }
    }];
}

/*录音按钮松开*/
- (void)voiceBtnTouchUp:(UIButton*)button{
    //隐藏动画
    UIViewController * delegateVC = (UIViewController*)self.delegate;
    [XQQVoiceAnimationView hideAnimationWithView:delegateVC.view];
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            NSLog(@"%@",recordPath);
            if (recordPath) {
                //代理发送
                if (self.delegate && [self.delegate respondsToSelector:@selector(sendVoiceMessage:aDuration:)]) {
                    [self.delegate sendVoiceMessage:recordPath aDuration:aDuration];
                }
            }else{
                [delegateVC.view showToastWithStr:@"还没说话呢"];
            }
        }
    }];
}

/*表情按钮点击*/
- (void)faceBtnDidPress:(UIButton*)button{
    if (_inputText.inputView == nil) {
        [UIView animateWithDuration:1.f animations:^{
             _inputText.inputView = _faceView;
        }];
        [self setBtnImage:@"ToolViewKeyboard" button:button];
        //左侧按钮修改
        [self setBtnImage:@"ToolViewInputVoice" button:_leftBtn];
        _leftBtnDidPress = NO;
        _voiceBtn.hidden = YES;
        _isFaceViewShow = YES;
    }else{
        _inputText.inputView = nil;
        _isFaceViewShow = NO;
        [self setBtnImage:@"ToolViewEmotion" button:button];
    }
    _isKeyBoard = YES;
    [self.inputText endEditing:YES];
    _isKeyBoard = NO;
    [self.inputText becomeFirstResponder];
}

/*右侧按钮点击*/
- (void)rightBtnDidPress:(UIButton*)button{
    if (_inputText.inputView == nil) {
        _inputText.inputView = _otherView;
        //左侧按钮修改
        [self setBtnImage:@"ToolViewInputVoice" button:_leftBtn];
        _leftBtnDidPress = NO;
        _voiceBtn.hidden = YES;
    }else{
        _inputText.inputView = nil;
    }
    _isKeyBoard = YES;
    [self.inputText endEditing:YES];
    _isKeyBoard = NO;
    [self.inputText becomeFirstResponder];
    //表情按钮修改
    [self setBtnImage:@"ToolViewEmotion" button:_faceBtn];
}

/*左侧按钮点击*/
- (void)leftBtnDidPress:(UIButton*)button{
    if (_leftBtnDidPress) {
        [self setBtnImage:@"ToolViewInputVoice" button:button];
        _voiceBtn.hidden = YES;
        [self becomeResponder];
        _leftBtnDidPress = NO;
    }else{
        _voiceBtn.hidden = NO;
        [self setBtnImage:@"ToolViewEmotion" button:_faceBtn];
        [self resignResponder];
        [self setBtnImage:@"ToolViewKeyboard" button:button];
        _leftBtnDidPress = YES;
    }
}

/*释放第一响应者*/
- (void)resignResponder{
    [_inputText resignFirstResponder];
    _inputText.inputView = nil;
}

/*成为第一响应者*/
- (void)becomeResponder{
    if (_inputText) {
        [_inputText becomeFirstResponder];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image !=nil) {
        //处理图片
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendImageMessage:)]) {
            [self.delegate sendImageMessage:image];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - sendLocationDelegate

- (void)sendMyLocationWithLocationModel:(BMKPoiInfo*)locationModel AndLocationImage:(UIImage*)locationImage{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendLocationMessage:)]) {
        [self.delegate sendLocationMessage:locationModel];
    }
}

#pragma mark - otherBtnDidPressDelegate

- (void)BtnDidPress:(NSInteger)btnTag{
    switch (btnTag) {
        case 0:{
            //进入相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController* imagePicker;
                imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate =self;
                imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
                if (self.delegate) {
                    UIViewController * vc = (UIViewController*)self.delegate;
                    imagePicker.navigationBar.barTintColor = vc.navigationController.navigationBar.barTintColor;
                    [vc presentViewController:imagePicker animated:YES completion:nil];
                }
            }
        }
            break;
        case 1:{
            //拍摄
            UIViewController * vc = (UIViewController*)self.delegate;
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                
                picker.delegate = self;
                
                picker.allowsEditing = YES; //是否可编辑
                
                //摄像头
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [vc.navigationController presentViewController:picker animated:YES completion:nil];
                
            }else{
                
                //如果没有提示用户
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"错误!" message:@"你没有摄像头!"preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * ac = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ac];
               
                [vc.navigationController presentViewController:alert animated:YES completion:nil];
            }
                
        }
            break;
        case 2:{
            //位置
            XQQChatLocationController * locationVC = [[XQQChatLocationController alloc]init];
            locationVC.delegate = self;
            if (self.delegate) {
                [self resignResponder];
                UIViewController * vc = (UIViewController*)self.delegate;
                [vc.navigationController pushViewController:locationVC animated:YES];
            }
        }
            break;
        case 3:{
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) return;
    
    // 点击了完成按钮
    if ([textView.text hasSuffix:@"\n"]) {
        if ([textView.text isEqualToString:@"\n"]) {
            return;
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatInputViewDidEndEdit:)]) {
                
                NSString * outPutStr = [self fullText];
                
                [self.delegate chatInputViewDidEndEdit:[outPutStr substringToIndex:outPutStr.length-1]];
                
            }
        }
        textView.text = @"";
        [textView resignFirstResponder];
    }
}

#pragma mark - 键盘上升下降
-(void)KeyboardWillShow:(NSNotification *)notification
{
    if (_isKeyBoard) {
        return;
    }
    NSDictionary *info = [notification userInfo];
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    float keyboardHeight = keyboardSize.height;
    //获取键盘弹出的时间
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    self.xqq_y = iphoneHeight - 50;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeViewHeight:)]) {
        [self.delegate changeViewHeight:- keyboardHeight];
    }
}

- (void)KeyboardWillHide:(NSNotification*)notic{
    if (_isKeyBoard) {
        return;
    }
    self.xqq_y = iphoneHeight  - 50;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeViewHeight:)]) {
        [self.delegate changeViewHeight:0];
    }
}

#pragma mark - setter&getter


/** 插入一个表情到输入框 */
- (void)insertEmotion:(XQQFaceModel *)emotion
{
    if (emotion.code) {
        // insertText : 将文字插入到光标所在的位置
        [self.inputText insertText:emotion.code.emoji];
    } else if (emotion.png) {
        // 加载图片
        XQQEmotionAttachment *attch = [[XQQEmotionAttachment alloc] init];
        
        // 传递模型
        attch.emotion = emotion;
        
        // 设置图片的尺寸
        CGFloat attchWH = self.inputText.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        // 根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        // 插入属性文字到光标位置
        [self.inputText insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.inputText.font range:NSMakeRange(0, attributedText.length)];
        }];
    }
}

/** 获取输入框的文字 */
- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [self.inputText.attributedText enumerateAttributesInRange:NSMakeRange(0, self.inputText.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        XQQEmotionAttachment *attch = attrs[@"NSAttachment"];
        if (attch) { // 图片
            [fullText appendString:[NSString stringWithFormat:@"%@",attch.emotion.chs]];
        } else { // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [self.inputText.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}

//设置按钮图片
- (void)setBtnImage:(NSString*)imageName button:(UIButton*)button{
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@HL",imageName]] forState:UIControlStateHighlighted];
}

@end
