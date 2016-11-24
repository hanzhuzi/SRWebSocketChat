//
//  XRVerticalInteractiveTransitionAnimation.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/4.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "XRVerticalInteractiveTransitionAnimation.h"
#import <objc/runtime.h>

static const NSString * gestureKey = @"gestureKey";

@implementation XRVerticalInteractiveTransitionAnimation
{
    BOOL _shouldComplate; // 是否完成转场
    UIViewController * _viewController;
}

- (void)wireToViewController:(UIViewController *)viewController withOperation:(XRInteractiveOperation)opt
{
    if (opt == XRInteractiveOperationTab) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"tab not allowed use" userInfo:nil];
    }
    self.popOnRightToLeft = YES;
    self.operation = opt;
    _viewController = viewController;
    
    [self addGestureToView:_viewController.view];
}

// add pan gesture
- (void)addGestureToView:(UIView *)view
{
    // 获取手势
    UIPanGestureRecognizer * panGes = objc_getAssociatedObject(view, (__bridge const void*)gestureKey);
    
    if (panGes) {
        [view removeGestureRecognizer:panGes];
    }
    
    // 创建pan手势
    panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [view addGestureRecognizer:panGes];
    
    // 设置runtime 对象
    objc_setAssociatedObject(view, (__bridge const void *)gestureKey, panGes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGes
{
    CGPoint translation = [panGes translationInView:panGes.view.superview];
    CGPoint vel = [panGes velocityInView:panGes.view];
    
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan: {
            
            BOOL rightToLeftSwipe = vel.x < 0;
            
            // perform the required navigation operation ...
            
            if (self.operation == XRInteractiveOperationPop) {
                // for pop operation, fire on right-to-left
                if ((self.popOnRightToLeft && rightToLeftSwipe) ||
                    (!self.popOnRightToLeft && !rightToLeftSwipe)) {
                    self.interactiveWithProgress = YES;
                    [_viewController.navigationController popViewControllerAnimated:YES];
                }
            } else if (self.operation == XRInteractiveOperationTab) {
                // for tab controllers, we need to determine which direction to transition
                if (rightToLeftSwipe) {
                    if (_viewController.tabBarController.selectedIndex < _viewController.tabBarController.viewControllers.count - 1) {
                        self.interactiveWithProgress = YES;
                        _viewController.tabBarController.selectedIndex++;
                    }
                    
                } else {
                    if (_viewController.tabBarController.selectedIndex > 0) {
                        self.interactiveWithProgress = YES;
                        _viewController.tabBarController.selectedIndex--;
                    }
                }
            } else {
                // for dismiss, fire regardless of the translation direction
                self.interactiveWithProgress = YES;
                [_viewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.interactiveWithProgress) {
                // compute the current position
                CGFloat fraction = fabs(translation.x / 200.0);
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                _shouldComplate = (fraction > 0.5);
                
                // if an interactive transitions is 100% completed via the user interaction, for some reason
                // the animation completion block is not called, and hence the transition is not completed.
                // This glorious hack makes sure that this doesn't happen.
                // see: https://github.com/ColinEberhardt/VCTransitionsLibrary/issues/4
                if (fraction >= 1.0)
                    fraction = 0.99;
                
                [self updateInteractiveTransition:fraction];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.interactiveWithProgress) {
                self.interactiveWithProgress = NO;
                if (!_shouldComplate || panGes.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        default:
            break;
    }
}

@end



