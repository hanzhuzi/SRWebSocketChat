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
    
    [containerView addSubview:fromView];
    UIButton * chatButton = ((ViewController *)fromVC).comingButton;
    
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        chatButton.center = fromView.center;
    } completion:^(BOOL finished) {
        [containerView addSubview:toView];
        // start circle maskLayer path.
        UIBezierPath * startCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(fromView.center.x, fromView.center.y, 0, 0)];
        CGPoint extrePoint = CGPointMake(fromView.center.x, fromView.center.y);
        CGFloat radius = sqrt(extrePoint.x * extrePoint.x + extrePoint.y * extrePoint.y);
        UIBezierPath * endCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(fromView.center.x, fromView.center.y, 0, 0), -radius, -radius)];
        
        // mask layer
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = startCirclePath.CGPath;
        toView.layer.mask = maskLayer;
        
        // basic animation
        CABasicAnimation * maskAnimi = [CABasicAnimation animationWithKeyPath:@"path"];
        maskAnimi.fromValue = (__bridge id _Nullable)startCirclePath.CGPath;
        maskAnimi.toValue   = (__bridge id _Nullable)(endCirclePath.CGPath);
        maskAnimi.duration = self.duration - 2.0;
        maskAnimi.fillMode = kCAFillModeForwards;
        maskAnimi.removedOnCompletion = NO;
        maskAnimi.delegate = self;
        [maskLayer addAnimation:maskAnimi forKey:@"pushpath"];
    }];
}

/**
 backwards animated
 */
- (void)excuteBackWardsAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    self.transitonCtx = transitionContext;
    UIView * containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor lightGrayColor];
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    UIButton * chatButton = ((ViewController *)toVC).comingButton;
    
    // start circle maskLayer path.
    UIBezierPath * startCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(fromView.center.x, fromView.center.y, 0, 0)];
    CGPoint extrePoint = CGPointMake(fromView.center.x, fromView.center.y);
    CGFloat radius = sqrt(extrePoint.x * extrePoint.x + extrePoint.y * extrePoint.y);
    UIBezierPath * endCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(fromView.center.x, fromView.center.y, 0, 0), -radius, -radius)];
    
    // mask layer
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCirclePath.CGPath;
    fromView.layer.mask = maskLayer;
    
    // basic animation
    CABasicAnimation * maskAnimi = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimi.fromValue = (__bridge id _Nullable)endCirclePath.CGPath;
    maskAnimi.toValue   = (__bridge id _Nullable)(startCirclePath.CGPath);
    maskAnimi.duration = 2.0;
    maskAnimi.fillMode = kCAFillModeForwards;
    maskAnimi.removedOnCompletion = NO;
    [maskLayer addAnimation:maskAnimi forKey:@"poppath"];
    
    [UIView animateWithDuration:self.duration - 2.0 delay:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
        chatButton.frame = CGRectMake(toView.es_maxX - 50.0 - 20.0, 30.0, 50.0, 50.0);
    } completion:^(BOOL finished) {
        [self.transitonCtx completeTransition:![self.transitonCtx transitionWasCancelled]];
        [self.transitonCtx viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    }];
}

#pragma mark - CoreAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitonCtx completeTransition:![self.transitonCtx transitionWasCancelled]];
    [self.transitonCtx viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}

@end
