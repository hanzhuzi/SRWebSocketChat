//
//  DetailViewController.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/18.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "DetailViewController.h"
#import "XRMoveTransitionAnimation.h"

@interface DetailViewController ()

@property (nonatomic, strong) UIImageView * myImageView;
@property (strong, nonatomic) XRMoveTransitionAnimation * fadeAnimator;

@end

@implementation DetailViewController

- (XRMoveTransitionAnimation *)fadeAnimator
{
    if (nil == _fadeAnimator) {
        _fadeAnimator = [[XRMoveTransitionAnimation alloc] init];
    }
    return _fadeAnimator;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myImageView = [[UIImageView alloc] init];
    self.myImageView.image = [UIImage imageNamed:@"header.jpeg"];
    self.myImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 140.0);
    
//    [self.view addSubview:self.myImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (fromVC == self) {
        // pop
        self.navigationController.delegate = nil;
        self.fadeAnimator.reverse = YES;
        return self.fadeAnimator;
    }
    else if (toVC == self) {
        // push
        self.navigationController.delegate = nil;
        self.fadeAnimator.reverse = NO;
        return self.fadeAnimator;
    }
    return nil;
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
