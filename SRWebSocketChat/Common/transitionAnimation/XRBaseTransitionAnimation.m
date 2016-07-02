//
//  SRBasePushAnimation.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/30.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "XRBaseTransitionAnimation.h"

@implementation XRBaseTransitionAnimation

- (instancetype)init
{
    if (self = [super init]) {
        self.duration = 1.0; // 默认1.0s
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * fromView = fromVC.view;
    UIView * toView   = toVC.view;
    [self animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    // base nothings.
}

@end
