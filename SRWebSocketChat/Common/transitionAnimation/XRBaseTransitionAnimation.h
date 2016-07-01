//
//  XRBaseTransitionAnimation.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/30.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 push \ pop animation base class.
 */
@interface XRBaseTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

/**
 reverse push or pop.
 */
@property (nonatomic, assign) BOOL reverse;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval duration;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView;

@end
