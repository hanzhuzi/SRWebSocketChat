//
//  SRChatViewController.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 * @brief 聊天室页面
 *
 * @by    黯丶野火
 */

#import "SRChatViewController.h"
#import "SRChatInputToolBar.h"

@interface SRChatViewController ()<SRChatInputToolBarDelegate>

@property (nonatomic, strong) SRChatInputToolBar * inputToolBar;

@end

@implementation SRChatViewController

#pragma mark - initial
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

+ (instancetype)defaultChatViewController
{
    static SRChatViewController * chatViewCtrl = nil;
    static dispatch_once_t onceToken = 0l;
    dispatch_once(&onceToken, ^{
        if (!chatViewCtrl) {
            chatViewCtrl = [[SRChatViewController alloc] init];
        }
    });
    
    return chatViewCtrl;
}

#pragma mark - getter & setter

- (SRChatInputToolBar *)inputToolBar
{
    if (nil == _inputToolBar) {
        _inputToolBar = [[SRChatInputToolBar alloc] initWithFrame:CGRectMake(0, self.view.es_maxY - InputToolBarMinHeight, self.view.es_width, InputToolBarMinHeight)];
        _inputToolBar.delegate = self;
    }
    return _inputToolBar;
}

- (void)setupGestures
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Actions

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    __weak __typeof(self) weakSelf = self;
    CGRect inputFrame = CGRectMake(0.0, keyboardFrame.origin.y - self.inputToolBar.es_height, self.inputToolBar.es_width, self.inputToolBar.es_height);
    void (^animate) (void) = ^{
        weakSelf.inputToolBar.frame = inputFrame;
    };
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:animate completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect inputFrame = CGRectMake(0.0, keyboardFrame.origin.y - self.inputToolBar.es_height, self.inputToolBar.es_width, self.inputToolBar.es_height);
    __weak __typeof(self) weakSelf = self;
    void (^animate)(void) = ^{
        weakSelf.inputToolBar.frame = inputFrame;
    };
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:animate completion:^(BOOL finished) {
        
    }];
}

#pragma mark - life cycle

- (void)viewDidLoad
{     
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupGestures];
    [self.view addSubview:self.inputToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - delegates methods.

#pragma mark - SRChatInputToolBarDelegate

- (void)chatInputToolBar:(SRChatInputToolBar *)inputToolBar didReciveBarHeightChanged:(CGFloat)barHeight
{
    CGRect barFrame = self.inputToolBar.frame;
    CGFloat offSet = barHeight - self.inputToolBar.es_height;
    barFrame.size.height = barHeight;
    barFrame.origin.y = barFrame.origin.y - offSet;
    [self.inputToolBar setFrame:barFrame animated:YES];
}


@end
