//
//  XRTranslateTransitionAnimation.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/30.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 two viewController translation animate
 */

#import "XRTranslateTransitionAnimation.h"

@interface XRTranslateTransitionAnimation ()

@end

@implementation XRTranslateTransitionAnimation

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
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    
    toView.frame = CGRectMake(-mainSize.width * 0.25, 0, mainSize.width, mainSize.height);
    fromView.frame = CGRectMake(0, 0, mainSize.width, mainSize.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        toView.frame = CGRectMake(0, 0.0, mainSize.width, mainSize.height);
        fromView.frame = CGRectMake(mainSize.width, 0, mainSize.width, mainSize.height);
        containerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            toView.frame = CGRectMake(-mainSize.width * 0.25, 0, mainSize.width, mainSize.height);
            fromView.frame = CGRectMake(0, 0, mainSize.width, mainSize.height);
        }
        else {
            toView.frame = CGRectMake(0, 0.0, mainSize.width, mainSize.height);
            fromView.frame = CGRectMake(mainSize.width, 0, mainSize.width, mainSize.height);
        }
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
    
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    
    toView.frame = CGRectMake(mainSize.width * 0.75, 0.0, mainSize.width, mainSize.height);
    fromView.frame = CGRectMake(0, 0, mainSize.width, mainSize.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        toView.frame = CGRectMake(0.0, 0.0, mainSize.width, mainSize.height);
        fromView.frame = CGRectMake(-mainSize.width, 0, mainSize.width, mainSize.height);
        containerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            toView.frame = CGRectMake(mainSize.width * 0.75, 0.0, mainSize.width, mainSize.height);
            fromView.frame = CGRectMake(0, 0, mainSize.width, mainSize.height);
        }
        else {
            toView.frame = CGRectMake(0.0, 0.0, mainSize.width, mainSize.height);
            fromView.frame = CGRectMake(-mainSize.width, 0, mainSize.width, mainSize.height);
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
