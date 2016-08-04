//
//  XRCicleTransitionAnimation.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/2.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 - @brief Mask 转场动画.
 push \ pop animator
 present \ dismiss animator
 
 - @by    黯丶野火
 */

#import "XRCicleTransitionAnimation.h"
#import "ViewController.h"

@interface XRCicleTransitionAnimation ()
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitonCtx;
@end

@implementation XRCicleTransitionAnimation

- (instancetype)init
{
    if (self = [super init]) {
        self.duration = SRChatButtonMoveTime + SRChatViewMovingTime;
    }
    return self;
}

// animated.
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    if (self.reverse) {
        // pop \ dismiss
        [self excuteBackWardsAnimationTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
    else {
        // push \ present
        [self excuteForWardsAnimationTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
}

// forwards animated.
- (void)excuteForWardsAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    self.transitonCtx = transitionContext;
    UIView * containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor lightGrayColor];
    
    [containerView addSubview:fromView];
    __weak __typeof(self) weakSelf = self;
    if (fromVC && [fromVC isKindOfClass:[ViewController class]]) {
        UIButton * chatButton = ((ViewController *)fromVC).comingButton;
        
        [UIView animateWithDuration:SRChatButtonMoveTime delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            chatButton.center = fromView.center;
        } completion:^(BOOL finished) {
            [containerView addSubview:toView];
            // start circle path.
            UIBezierPath * startCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(fromView.center.x, fromView.center.y, 0, 0)];
            CGPoint extrePoint = CGPointMake(fromView.center.x, fromView.center.y);
            CGFloat radius = sqrt(extrePoint.x * extrePoint.x + extrePoint.y * extrePoint.y);
            // end circle path.
            UIBezierPath * endCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(fromView.center.x, fromView.center.y, 0, 0), -radius, -radius)];
            
            // mask layer
            CAShapeLayer * maskLayer = [CAShapeLayer layer];
            maskLayer.path = startCirclePath.CGPath;
            toView.layer.mask = maskLayer;
            
            // basic animation
            CABasicAnimation * maskAnimi = [CABasicAnimation animationWithKeyPath:@"path"];
            maskAnimi.fromValue = (__bridge id _Nullable)startCirclePath.CGPath;
            maskAnimi.toValue   = (__bridge id _Nullable)(endCirclePath.CGPath);
            maskAnimi.duration = weakSelf.duration - SRChatButtonMoveTime;
            maskAnimi.fillMode = kCAFillModeForwards;
            maskAnimi.removedOnCompletion = NO;
            maskAnimi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            maskAnimi.delegate = weakSelf;
            [maskLayer addAnimation:maskAnimi forKey:@"forwardsAnimation"];
        }];
    }
}

// backwards animated.
- (void)excuteBackWardsAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    self.transitonCtx = transitionContext;
    UIView * containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor lightGrayColor];
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    
    if (toVC &&  [toVC isKindOfClass:[ViewController class]]) {
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
        maskAnimi.duration = SRChatButtonMoveTime;
        maskAnimi.fillMode = kCAFillModeForwards;
        maskAnimi.removedOnCompletion = NO;
        maskAnimi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [maskLayer addAnimation:maskAnimi forKey:@"poppathAnimation"];
        
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:self.duration - SRChatButtonMoveTime delay:SRChatButtonMoveTime options:UIViewAnimationOptionCurveLinear animations:^{
            chatButton.frame = CGRectMake(toView.es_maxX - SRChatButtonWH - 20.0, toView.es_maxY -SRChatButtonWH - 30.0, SRChatButtonWH, SRChatButtonWH);
        } completion:^(BOOL finished) {
            [weakSelf.transitonCtx completeTransition:![weakSelf.transitonCtx transitionWasCancelled]];
            [weakSelf.transitonCtx viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        }];
    }
}

#pragma mark - CoreAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitonCtx completeTransition:![self.transitonCtx transitionWasCancelled]];
    [self.transitonCtx viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
