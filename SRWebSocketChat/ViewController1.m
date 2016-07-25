//
//  ViewController1.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/18.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "ViewController1.h"
#import "DetailViewController.h"
#import "myCell.h"
#import "XRFadeTransitionAnimation.h"
#import "XRTranslateTransitionAnimation.h"
#import "XRMoveTransitionAnimation.h"
#import "XRMoveTransitionData.h"

@interface ViewController1 ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * myTableView;
@property (strong, nonatomic) XRMoveTransitionAnimation * fadeAnimator;

@end

@implementation ViewController1

- (XRMoveTransitionAnimation *)fadeAnimator
{
    if (nil == _fadeAnimator) {
        _fadeAnimator = [[XRMoveTransitionAnimation alloc] init];
    }
    return _fadeAnimator;
}


- (UITableView *)myTableView
{
    if (nil == _myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTableView];
    [self.myTableView registerClass:[myCell class] forCellReuseIdentifier:@"cellID"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

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
    myCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[myCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    myCell * mycell = [tableView cellForRowAtIndexPath:indexPath];
    if (mycell) {
        CGRect frame = [mycell convertRect:mycell.bounds toView:self.view];
        NSLog(@"%@", NSStringFromCGRect(frame));
        [XRMoveTransitionData shareTransitionData].animateImageView = mycell.myImageView;
        [XRMoveTransitionData shareTransitionData].fromRect = frame;
        [XRMoveTransitionData shareTransitionData].toRect = CGRectMake(0, 0, self.view.frame.size.width, 140.0);
    }
    
    DetailViewController * detailVc = [[DetailViewController alloc] init];
    self.navigationController.delegate = detailVc;
    [self.navigationController pushViewController:detailVc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
