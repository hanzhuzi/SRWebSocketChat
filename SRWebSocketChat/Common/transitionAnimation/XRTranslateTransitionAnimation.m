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
    
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    if (CGRectIsEmpty(toFrame)) {
        toFrame = [UIScreen mainScreen].bounds;
    }
    
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    
    [[transitionContext containerView] addSubview:toView];
    [[transitionContext containerView] addSubview:fromView];
    toView.frame = CGRectMake(-mainScreenSize.width, 0, mainScreenSize.width, mainScreenSize.height);
    fromView.frame = CGRectMake(0, 0, mainScreenSize.width, mainScreenSize.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        toView.frame = toFrame;
        
        fromView.frame = CGRectMake(mainScreenSize.width, 0, mainScreenSize.width, mainScreenSize.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

/**
 backwards animate
 */
- (void)excuteBackWardsAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    if (CGRectIsEmpty(toFrame)) {
        toFrame = [UIScreen mainScreen].bounds;
    }
    
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    
    [[transitionContext containerView] addSubview:toView];
    [[transitionContext containerView] addSubview:fromView];
    toView.frame = CGRectMake(mainScreenSize.width, 0, mainScreenSize.width, mainScreenSize.height);
    fromView.frame = CGRectMake(0, 0, mainScreenSize.width, mainScreenSize.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        toView.frame = toFrame;
        
        fromView.frame = CGRectMake(-mainScreenSize.width, 0, mainScreenSize.width, mainScreenSize.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
