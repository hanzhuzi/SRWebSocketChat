//
//  XRFadeTransitionAnimation.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/1.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "XRFadeTransitionAnimation.h"

@implementation XRFadeTransitionAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    if (self.reverse) {
        [self excuteBackWardsAnimationTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
    else {
        [self excuteForWardsAnimationTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
}

/**
 forwards animate
 */
- (void)excuteForWardsAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    UIView * containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor lightGrayColor];
    
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    
    fromView.alpha = 1.0;
    toView.alpha = 0.0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromView.alpha = 0.0;
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

/**
 backwards animate
 */
- (void)excuteBackWardsAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    UIView * containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor lightGrayColor];
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    fromView.alpha = 1.0;
    toView.alpha = 0.0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromView.alpha = 0.0;
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
