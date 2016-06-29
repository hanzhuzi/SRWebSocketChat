//
//  SRChatInputToolBar.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRChatInputToolBar.h"
#import "SRChatManager.h"

static const CGFloat InputTextViewMinHeight = 34.0;
static const CGFloat InputTextViewMaxHeight = 68.0;
static const CGFloat InputTextViewTopInsert = (InputToolBarMinHeight - InputTextViewMinHeight) * 0.5;

@interface SRChatInputToolBar ()<UITextViewDelegate>
{
    SRChatManager * chatManager;
}

@property (nonatomic, strong) UITextView * inputTextView;

@end

@implementation SRChatInputToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorWithRGB(244, 244, 244);
        
        chatManager = [SRChatManager defaultManager];
        [self addSubview:self.inputTextView];
    }
    return self;
}

- (UITextView *)inputTextView
{
    if (nil == _inputTextView) {
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, InputTextViewTopInsert, self.es_width - 20.0, InputTextViewMinHeight)];
        _inputTextView.backgroundColor = ColorWithRGB(252, 252, 252);
        _inputTextView.layer.cornerRadius = 5.0;
        _inputTextView.layer.borderColor = ColorWithRGB(234, 234, 234).CGColor;
        _inputTextView.layer.borderWidth = 1.0;
        _inputTextView.font = [UIFont systemFontOfSize:16.0];
        _inputTextView.textColor = [UIColor blackColor];
        _inputTextView.textAlignment = NSTextAlignmentJustified;
        _inputTextView.delegate = self;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTextView.enablesReturnKeyAutomatically = YES;
    }
    return _inputTextView;
}

- (void)setFrame:(CGRect)frame animated:(BOOL)animated
{
    CGRect textViewFrame = self.inputTextView.frame;
    textViewFrame.size.height = frame.size.height - InputTextViewTopInsert * 2.0;
    
    __weak __typeof(self) weakSelf = self;
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            weakSelf.frame = frame;
            weakSelf.inputTextView.frame = textViewFrame;
        } completion:^(BOOL finished) {
            [self layoutIfNeeded];
        }];
    }
    else {
        self.frame = frame;
        self.inputTextView.frame = textViewFrame;
        [self layoutIfNeeded];
    }
}

- (void)becomeTextViewFirstResponse
{
    [self.inputTextView becomeFirstResponder];
}

- (void)endTextViewEdting
{
    [self.inputTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect textViewFrame = textView.frame;
    CGSize textSize = [textView sizeThatFits:CGSizeMake(textView.es_width, 0)];
    CGFloat offSet = InputTextViewTopInsert;
    textView.scrollEnabled = (textSize.height > InputTextViewMaxHeight - offSet);
    
    if (textView.scrollEnabled) {
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 2, 1)];
    }
    
    textViewFrame.size.height = MAX(34.0, MIN(InputTextViewMaxHeight, textSize.height));
    CGFloat barHeight = textViewFrame.size.height + InputTextViewTopInsert * 2.0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatInputToolBar:didReciveBarHeightChanged:)]) {
        [self.delegate chatInputToolBar:self didReciveBarHeightChanged:barHeight];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEmpty]) {
        textView.enablesReturnKeyAutomatically = YES;
    }
    else {
        textView.enablesReturnKeyAutomatically = NO;
    }
    
    if ([text isEqualToString:@"\n"] && range.length == 0) {
        // 发送操作，发送消息.
        NSString * sendMsg = textView.text;
        [chatManager sendMessage:sendMsg];
        textView.text = @"";
        [self textViewDidChange:textView];
        return NO;
    }
    else if ([text isEqualToString:@""] && range.length == 1) {
        // 删除操作，处理删除自定义表情操作.
        return YES;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

@end
