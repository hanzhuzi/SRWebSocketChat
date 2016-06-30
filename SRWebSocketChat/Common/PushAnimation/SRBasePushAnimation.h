//
//  SRBasePushAnimation.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/30.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 push animation base class.
 */
@interface SRBasePushAnimation : NSObject<UIViewControllerAnimatedTransitioning>

/**
 reverse YES back.
 */
@property (nonatomic, assign) BOOL reverse;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval duration;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView;

@end
