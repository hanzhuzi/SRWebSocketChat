//
//  XRCicleTransitionAnimation.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/2.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "XRCicleTransitionAnimation.h"
#import "ViewController.h"

@interface XRCicleTransitionAnimation ()
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitonCtx;
@end

@implementation XRCicleTransitionAnimation

// animated.
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    if (self.reverse) {
        // pop
        [self excuteBackWardsAnimationTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
    else {
        // push
        [self excuteForWardsAnimationTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
}

/**
 forwards animated
 */
- (void)excuteForWardsAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    self.transitonCtx = transitionContext;
    UIView * containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor lightGrayColor];
    
    [containerView addSubview:toView];
    UIButton * chatButton = ((ViewController *)fromVC).comingButton;
    
    // start circle maskLayer path.
    UIBezierPath * startCirclePath = [UIBezierPath bezierPathWithOvalInRect:chatButton.frame];
    CGPoint extrePoint = CGPointMake(chatButton.center.x, chatButton.center.y - toVC.view.es_height);
    CGFloat radius = sqrt(extrePoint.x * extrePoint.x + extrePoint.y * extrePoint.y);
    UIBezierPath * endCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(chatButton.frame, -radius, -radius)];
    
    // mask layer
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = startCirclePath.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    // basic animation
    CABasicAnimation * maskAnimi = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimi.fromValue = (__bridge id _Nullable)startCirclePath.CGPath;
    maskAnimi.toValue   = (__bridge id _Nullable)(endCirclePath.CGPath);
    maskAnimi.duration = self.duration;
    maskAnimi.delegate = self;
    [maskLayer addAnimation:maskAnimi forKey:@"path"];
}

/**
 backwards animated
 */
- (void)excuteBackWardsAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    UIView * containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor lightGrayColor];
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitonCtx completeTransition:![self.transitonCtx transitionWasCancelled]];
//    [self.transitonCtx viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}



@end
