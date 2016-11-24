//
//  SRChatViewController.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 * @brief 聊天室
 *
 * @by    黯丶野火
 */

#import "SRChatViewController.h"
#import "SRChatInputToolBar.h"
#import "SRChatManager.h"
#import "SRChatTextMessageLeftCell.h"
#import "SRChatTextMessageRightCell.h"
#import "TTTAttributedLabel.h"
#import "SRChatTextMessage.h"

@interface SRChatViewController ()<SRChatInputToolBarDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, SRChatManagerDelegate>
{
    CGRect tempTableFrame;
    CGFloat preOffSetY;
    NSString * room_Id; // 聊天室id
}

@property (nonatomic, strong) UITableView * myTableView;
@property (nonatomic, strong) SRChatInputToolBar * inputToolBar;
@property (nonatomic, assign) BOOL   keyboardShow;
@property (nonatomic, strong) NSMutableArray * chatMessages;
@property (nonatomic, strong) SRChatManager * chatManager;
@property (nonatomic, strong) UIView * navigationBarView;

@end

@implementation SRChatViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.inputToolBar.delegate = nil;
    self.inputToolBar = nil;
    self.chatManager.delegate = nil;
    NSLog(@"%@ dealloc!", NSStringFromClass([self class]));
}

#pragma mark - initial
- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:kApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEndForeground) name:kApplicationDidEnterForegroundNotification object:nil];
    }
    return self;
}

- (instancetype)initWithRoomID:(NSString *)roomId
{
    if (self = [self init]) {
        room_Id = roomId;
    }
    return self;
}

+ (instancetype)chatViewControllerWithRoomID:(NSString *)roomId
{
    SRChatViewController * chatViewCtrl = [[SRChatViewController alloc] initWithRoomID:roomId];
    return chatViewCtrl;
}

#pragma mark - getter & setter

- (UIView *)navigationBarView
{
    if (nil == _navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.es_width, 64.0)];
        _navigationBarView.backgroundColor = ColorWithRGB(160, 160, 160);
        
        UIButton * leftItem = [[UIButton alloc] init];
        leftItem.frame = CGRectMake(12.0, 22.0, 50.0, 40.0);
        [leftItem setTitle:@"返回" forState:UIControlStateNormal];
        [leftItem setTitleColor:ColorWithRGB(250, 250, 250) forState:UIControlStateNormal];
        [leftItem addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBarView addSubview:leftItem];
        
        UILabel * titleView = [[UILabel alloc] init];
        titleView.frame = CGRectMake((self.view.es_width - 100.0) * 0.5, 20, 100.0, 44.0);
        titleView.text = @"Chat Room";
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.textColor = ColorWithRGB(250, 250, 250);
        [_navigationBarView addSubview:titleView];
    }
    return _navigationBarView;
}

- (SRChatManager *)chatManager
{
    _chatManager = [SRChatManager defaultManager];
    if (!_chatManager.delegate) {
        _chatManager.delegate = self;
    }
    return _chatManager;
}

- (NSMutableArray *)chatMessages
{
    if (_chatMessages == nil) {
        _chatMessages = [NSMutableArray arrayWithArray:[SRChatManager defaultManager].chatMessages];
        
        for (SRChatTextMessage * textMessage in _chatMessages) {
            [self calculateCellHeightWithTextMessage:textMessage];
        }
    }
    return _chatMessages;
}

- (SRChatInputToolBar *)inputToolBar
{
    if (nil == _inputToolBar) {
        _inputToolBar = [[SRChatInputToolBar alloc] initWithFrame:CGRectMake(0, self.myTableView.es_maxY, self.view.es_width, InputToolBarMinHeight)];
        _inputToolBar.backgroundColor = ColorWithRGB(245, 245, 245);
        _inputToolBar.delegate = self;
    }
    return _inputToolBar;
}

- (UITableView *)myTableView
{
    if (nil == _myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.es_width, self.view.es_maxY - InputToolBarMinHeight - 64.0) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.bounces = YES;
        _myTableView.backgroundColor = ColorWithRGB(234, 234, 234);
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.showsVerticalScrollIndicator = NO;
        [_myTableView registerClass:[SRChatTextMessageLeftCell class] forCellReuseIdentifier:@"SRChatTextMessageLeftCell"];
        [_myTableView registerClass:[SRChatTextMessageRightCell class] forCellReuseIdentifier:@"SRChatTextMessageRightCell"];
        _myTableView.tableFooterView = [[UIView alloc] init];
        tempTableFrame = _myTableView.frame;
    }
    return _myTableView;
}

- (void)setupGestures
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Actions

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  计算cell高度
- (void)calculateCellHeightWithTextMessage:(SRChatTextMessage *)textMessage
{
    switch (textMessage.msgFromType) {
        case SRChatMessageFromTypeMe:
        {
            textMessage.heightForCell = [SRChatTextMessageRightCell calculateSRChatTextMessageRightCellHeightWithTextMessage:textMessage];
        }
            break;
        case SRChatMessageFromTypeOther:
        {
            // 接收的消息
            textMessage.heightForCell = [SRChatTextMessageLeftCell calculateSRChatTextMessageLeftCellHeightWithTextMessage:textMessage];
        }
            break;
        case SRChatMessageFromTypeSystem:
        {
            // 系统消息
        }
            break;
        default:
            break;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.inputToolBar endTextViewEdting];
}

- (void)applicationDidEnterBackground
{
    NSLog(@"应用程序已经进入后台");
    [self.inputToolBar endTextViewEdting];
}

- (void)applicationDidEndForeground
{
    NSLog(@"应用程序已经进入前台");
    [self.inputToolBar becomeTextViewFirstResponse];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    __weak __typeof(self) weakSelf = self;
    CGRect tableFrame = tempTableFrame;
    tableFrame.size.height -= keyboardFrame.size.height;
    
    CGRect inputFrame = CGRectMake(0.0, CGRectGetMaxY(tableFrame), self.inputToolBar.es_width, self.inputToolBar.es_height);
    
    void (^animate) (void) = ^{
        weakSelf.inputToolBar.frame = inputFrame;
        weakSelf.myTableView.frame = tableFrame;
        // 滚动和动画同时进行.
        [weakSelf.myTableView reloadData];
        // 滚动到最后row
        if (weakSelf.chatMessages.count > 0) {
            [weakSelf.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.chatMessages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    };
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:animate completion:^(BOOL finished) {
        weakSelf.keyboardShow = YES;
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    if (!_keyboardShow) {
        return;
    }
    NSDictionary * userInfo = [notification userInfo];
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect tableFrame = tempTableFrame;
    CGRect inputFrame = CGRectMake(0.0, CGRectGetMaxY(tableFrame), self.inputToolBar.es_width, self.inputToolBar.es_height);
    
    __weak __typeof(self) weakSelf = self;
    void (^animate)(void) = ^{
        weakSelf.inputToolBar.frame = inputFrame;
        weakSelf.myTableView.frame = tableFrame;
    };
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:animate completion:^(BOOL finished) {
        weakSelf.keyboardShow = NO;
    }];
}

#pragma mark - life cycle

- (void)viewDidLoad
{     
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.navigationBarView];
    [self setupGestures];
    self.chatManager.delegate = self;
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.inputToolBar];
    preOffSetY = -1000.0;
    
    UIScreenEdgePanGestureRecognizer * panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 从用户体验来讲，进入聊天页面谈键盘很不错，但是使用第三方键盘，如搜狗输入法等，体验将大打折扣，键盘的监听会有延时。
    // 因此在这里是收键盘.
    [self.inputToolBar endTextViewEdting];
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.chatManager closeServer];
    self.chatManager.status = SRChatManagerStatusLogOffByUser; // 用户自己下线
}

#pragma mark - delegates methods.

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

// 收到消息
- (void)chatManager:(SRChatManager *)chatManager didReciveNewMessage:(SRChatTextMessage *)textMessage
{
    [self calculateCellHeightWithTextMessage:textMessage];
    [self.chatMessages addObject:textMessage];
    [self.myTableView reloadData];
    // 滚动到最后row
    if (self.chatMessages.count > 0) {
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

// 发送消息
- (void)chatManager:(SRChatManager *)chatManager didSendNewMessage:(SRChatTextMessage *)textMessage
{
    [self calculateCellHeightWithTextMessage:textMessage];
    [self.chatMessages addObject:textMessage];
    [self.myTableView reloadData];
    // 滚动到最后row
    if (self.chatMessages.count > 0) {
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.chatMessages.count) {
        SRChatTextMessage * message = self.chatMessages[indexPath.row];
        
        switch (message.msgFromType) {
            case SRChatMessageFromTypeMe:
            {
                SRChatTextMessageRightCell * rightTextCell = [tableView dequeueReusableCellWithIdentifier:@"SRChatTextMessageRightCell"];
                
                if (!rightTextCell) {
                    rightTextCell = [[SRChatTextMessageRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SRChatTextMessageRightCell"];
                }
                
                rightTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return rightTextCell;
            }
                break;
            case SRChatMessageFromTypeOther:
            {
                // 接收的消息
                // 发送的消息
                SRChatTextMessageLeftCell * leftTextCell = [tableView dequeueReusableCellWithIdentifier:@"SRChatTextMessageLeftCell"];
                
                if (!leftTextCell) {
                    leftTextCell = [[SRChatTextMessageLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SRChatTextMessageLeftCell"];
                }
                
                leftTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return leftTextCell;
            }
                break;
            case SRChatMessageFromTypeSystem:
            {
                // 系统消息
                return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            }
                break;
            default:
                break;
        }
    }
    else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.chatMessages.count) {
        return;
    }
    
    SRChatTextMessage * message = self.chatMessages[indexPath.row];
    
    switch (message.msgFromType) {
        case SRChatMessageFromTypeMe:
        {
            SRChatTextMessageRightCell * rightTextCell = (SRChatTextMessageRightCell *)cell;
            [rightTextCell configurationSRChatTextMessageRightCellWithSRchatTextMessage:message];
        }
            break;
        case SRChatMessageFromTypeOther:
        {
            // 接收的消息
            // 发送的消息
            SRChatTextMessageLeftCell * leftTextCell = (SRChatTextMessageLeftCell *)cell;
            [leftTextCell configurationSRChatTextMessageLeftCellWithSRchatTextMessage:message];
        }
            break;
        case SRChatMessageFromTypeSystem:
        {
            // 系统消息
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.chatMessages.count) {
        return 0.0;
    }
    
    SRChatTextMessage * message = self.chatMessages[indexPath.row];
    return message.heightForCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.myTableView]) {
        CGFloat offSetY = self.myTableView.contentOffset.y;
        if (offSetY != preOffSetY) {
            if (preOffSetY > offSetY) {
                if (self.keyboardShow) {
                    [self.inputToolBar endTextViewEdting];
                    self.keyboardShow = NO;
                }
            }
            else {
                CGFloat contentOffSetY = self.myTableView.contentSize.height - self.myTableView.es_height;
                if (offSetY > contentOffSetY + 70.0) {
                    if (!self.keyboardShow) {
//                        [self.inputToolBar becomeTextViewFirstResponse];
                    }
                }
            }
            preOffSetY = offSetY;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 处理与TTTAttributedLabel的手势冲突问题.
    if ([touch.view isKindOfClass:[TTTAttributedLabel class]]) {
        TTTAttributedLabel * tttLabel = (TTTAttributedLabel *)touch.view;
        if ([tttLabel containslinkAtPoint:[touch locationInView:tttLabel]]) {
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}

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
