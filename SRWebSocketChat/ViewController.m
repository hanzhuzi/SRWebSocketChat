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
    SRChatManager * manager;
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *passwordTextField;
}
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)loginAction:(id)sender {
    
#if 1
    
    UIButton * loginButton = (UIButton *)sender;
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
    manager.userInfo.req_type = @"login";
    manager.userInfo.userName = userName;
    manager.userInfo.passWord = passWord;
    manager.userInfo.room_id  = @"1";
    [manager openServer];  // 建立连接之后默认登录服务器
#else
    SRChatViewController * chatViewCtrl = [SRChatViewController defaultChatViewController];
    [self.navigationController pushViewController:chatViewCtrl animated:YES];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    manager = [SRChatManager defaultManager];
    manager.delegate = self;
    
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
            break;
        case SRChatManagerStatusClose:
            NSLog(@"连接关闭");
            break;
        case SRChatManagerStatusLogin:
        {
            NSLog(@"上线");
            __block BOOL isPushed = NO;
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj && [obj isKindOfClass:[SRChatViewController class]]) {
                    isPushed = YES;
                    *stop = YES;
                }
            }];
            if (!isPushed) {
                SRChatViewController * chatViewCtrl = [SRChatViewController defaultChatViewController];
                [self.navigationController pushViewController:chatViewCtrl animated:YES];
            }
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
