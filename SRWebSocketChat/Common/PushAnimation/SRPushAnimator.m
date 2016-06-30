//
//  SRPushAnimator.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/30.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRPushAnimator.h"

@interface SRPushAnimator ()

@property (nonatomic, strong) UIViewController * fromViewController;
@property (nonatomic, strong) UIViewController * toViewController;

@end

@implementation SRPushAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect toFrame = [transitionContext finalFrameForViewController:self.toViewController];
    if (CGRectIsEmpty(toFrame)) {
        toFrame = [UIScreen mainScreen].bounds;
    }
    
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    
    [[transitionContext containerView] addSubview:self.toViewController.view];
    [[transitionContext containerView] addSubview:self.fromViewController.view];
    [[transitionContext containerView] sendSubviewToBack:self.toViewController.view];
    self.toViewController.view.frame = CGRectMake(-mainScreenSize.width, 0, mainScreenSize.width, mainScreenSize.height);
    self.fromViewController.view.frame = CGRectMake(0, 0, mainScreenSize.width, mainScreenSize.height);
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.toViewController.view.frame = toFrame;
        
        weakSelf.fromViewController.view.frame = CGRectMake(mainScreenSize.width, 0, mainScreenSize.width, mainScreenSize.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
