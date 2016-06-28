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

@interface ViewController ()<SRChatManagerDelegate>
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

- (IBAction)loginAction:(id)sender {
    
#if 1
    
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

#endif
}

- (SRChatManager *)chatManager
{
    _chatManager = [SRChatManager defaultManager];
    if (!_chatManager.delegate) {
        _chatManager.delegate = self;
    }
    return _chatManager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
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

@end
