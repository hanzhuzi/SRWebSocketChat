//
//  ViewController.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "ViewController.h"
#import "SRChatManager.h"
#import "SRChatUserInfo.h"
#import "SRChatViewController.h"
#import "XRTranslateTransitionAnimation.h"

@interface ViewController ()<SRChatManagerDelegate, UIViewControllerTransitioningDelegate>
{
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UIButton *loginButton;
}

@property (nonatomic, strong) SRChatManager * chatManager;

@end

@implementation ViewController

- (void)dealloc
{
    self.chatManager.delegate = nil;
}

- (UIButton *)comingButton
{
    if (nil == _comingButton) {
        static const CGFloat buttonWH = 50.0;
        _comingButton = [UIButton new];
        _comingButton.frame = CGRectMake(self.view.es_maxX - buttonWH - 20.0, 30.0, buttonWH, buttonWH);
        _comingButton.backgroundColor = [UIColor redColor];
        _comingButton.layer.cornerRadius = buttonWH * 0.5;
        _comingButton.layer.shadowColor = ColorWithRGB(100, 100, 100).CGColor;
        _comingButton.layer.shadowOffset = CGSizeMake(0, 0);
        _comingButton.layer.shadowOpacity = 1.0;
        _comingButton.layer.masksToBounds = NO;
        _comingButton.layer.shadowRadius = 5.0;
        
        [_comingButton setTitle:@"聊天吧" forState:UIControlStateNormal];
        [_comingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comingButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    }
    return _comingButton;
}

- (IBAction)loginAction:(id)sender {
    
#if 0
    
    [loginButton setTitle:@"登录中..." forState:UIControlStateNormal];
    
    NSString * userName = userNameTextField.text;
    NSString * passWord = passwordTextField.text;
    
    if (!userName || userName.length == 0) {
        return;
    }
    
    if (!passWord || passWord.length == 0) {
        //        return;
    }
    // 必须设置请求类型，用户名，密码，房间号.
    self.chatManager.userInfo.req_type = @"login";
    self.chatManager.userInfo.userName = userName;
    self.chatManager.userInfo.passWord = passWord;
    self.chatManager.userInfo.room_id  = @"1";
    [self.chatManager openServer];  // 建立连接之后默认登录服务器
#else
    SRChatViewController * chatViewCtrl = [SRChatViewController chatViewControllerWithRoomID:self.chatManager.userInfo.room_id];
    [self.navigationController pushViewController:chatViewCtrl animated:YES];
#endif
}

- (SRChatManager *)chatManager
{
    _chatManager = [SRChatManager defaultManager];
    _chatManager.delegate = self;
    return _chatManager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.transitioningDelegate = self;
    self.navigationItem.title = @"SRWebSocketChat";
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    

    [self.view addSubview:self.comingButton];
}

- (void)tapAction
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SRChatManagerDelegate

- (void)chatManager:(SRChatManager *)chatManager didReciveChatStatusChanged:(SRChatManagerStatus)status
{
    switch (status) {
        case SRChatManagerStatusOpen:
            NSLog(@"连接成功");
            [loginButton setTitle:@"连接服务器成功" forState:UIControlStateNormal];
            break;
        case SRChatManagerStatusClose:
            NSLog(@"连接关闭");
            break;
        case SRChatManagerStatusLogin:
        {
            NSLog(@"上线");
            [loginButton setTitle:@"登录成功" forState:UIControlStateNormal];
            __block BOOL isPushed = NO;
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj && [obj isKindOfClass:[SRChatViewController class]]) {
                    isPushed = YES;
                    *stop = YES;
                }
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!isPushed) {
                    SRChatViewController * chatViewCtrl = [SRChatViewController chatViewControllerWithRoomID:self.chatManager.userInfo.room_id];
                    [self.navigationController pushViewController:chatViewCtrl animated:YES];
                }
            });
        }
            break;
        case SRChatManagerStatusLogOffByServer:
            NSLog(@"网络或其他因素自动下线");
            break;
        case SRChatManagerStatusLogOffByUser:
            NSLog(@"用户手动下线");
            break;
        default:
            break;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.appDelegate.navigationAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.appDelegate.navigationAnimation;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

@end
