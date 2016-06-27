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
#import "SRChatManager.h"
#import "SRChatTextMessageLeftCell.h"
#import "SRChatTextMessageRightCell.h"
#import "TTTAttributedLabel.h"

@interface SRChatViewController ()<SRChatInputToolBarDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView * myTableView;
@property (nonatomic, strong) NSMutableArray * messageArray;
@property (nonatomic, strong) SRChatInputToolBar * inputToolBar;

@end

@implementation SRChatViewController

- (void)cleanChatViewController
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.inputToolBar.delegate = nil;
    self.inputToolBar = nil;
}

- (void)dealloc
{
    [self cleanChatViewController];
}

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
        _inputToolBar.backgroundColor = ColorWithRGB(245, 245, 245);
        _inputToolBar.delegate = self;
    }
    return _inputToolBar;
}

- (UITableView *)myTableView
{
    if (nil == _myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.es_width, self.view.es_height - 64.0 - InputToolBarMinHeight) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = ColorWithRGB(234, 234, 234);
        _myTableView.separatorColor = [UIColor clearColor];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.showsVerticalScrollIndicator = NO;
        [_myTableView registerClass:[SRChatTextMessageLeftCell class] forCellReuseIdentifier:@"SRChatTextMessageLeftCell"];
        [_myTableView registerClass:[SRChatTextMessageRightCell class] forCellReuseIdentifier:@"SRChatTextMessageRightCell"];
        _myTableView.tableFooterView = [[UIView alloc] init];
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
    
    CGRect tableFrame = self.myTableView.frame;
    tableFrame.origin.y -= keyboardFrame.size.height;
    
    void (^animate) (void) = ^{
        weakSelf.inputToolBar.frame = inputFrame;
        weakSelf.myTableView.frame = tableFrame;
    };
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:animate completion:^(BOOL finished) {
        [weakSelf.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect inputFrame = CGRectMake(0.0, keyboardFrame.origin.y - self.inputToolBar.es_height, self.inputToolBar.es_width, self.inputToolBar.es_height);
    
    CGRect tableFrame = self.myTableView.frame;
    tableFrame.origin.y += keyboardFrame.size.height;
    
    __weak __typeof(self) weakSelf = self;
    void (^animate)(void) = ^{
        weakSelf.inputToolBar.frame = inputFrame;
        weakSelf.myTableView.frame = tableFrame;
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
    
    self.navigationItem.title = @"聊天室";
    [self setupGestures];
    [self.view addSubview:self.myTableView];
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
    
    [[SRChatManager defaultManager] closeServer];
    [SRChatManager defaultManager].status = SRChatManagerStatusLogOffByUser; // 用户自己下线
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - delegates methods.

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        SRChatTextMessageLeftCell * leftTextCell = [tableView dequeueReusableCellWithIdentifier:@"SRChatTextMessageLeftCell"];
        
        if (!leftTextCell) {
            leftTextCell = [[SRChatTextMessageLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SRChatTextMessageLeftCell"];
        }
        
        leftTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return leftTextCell;
    }
    else {
        SRChatTextMessageRightCell * rightTextCell = [tableView dequeueReusableCellWithIdentifier:@"SRChatTextMessageRightCell"];
        
        if (!rightTextCell) {
            rightTextCell = [[SRChatTextMessageRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SRChatTextMessageRightCell"];
        }
        
        rightTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return rightTextCell;
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0;
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
