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
    
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            BOOL topToBottom = translation.y > 0;
            if (self.operation == XRInteractiveOperationPop) {
                if (topToBottom) {
                    self.interactiveWithProgress = YES;
                    [_viewController.navigationController popViewControllerAnimated:YES];
                }
            }
            else {
                // disMiss
                self.interactiveWithProgress = YES;
                [_viewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.interactiveWithProgress) {
                CGFloat fraction = translation.y / 200.0;
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                _shouldComplate = fraction > 0.5;
                
                // 如果 interactive transiton 是100%，那么动画将不会完成，转场也不会完成。
                if (fraction > 1.0) {
                    fraction = 0.999;
                }
                
                [self updateInteractiveTransition:fraction];
            }
        }
            break;
        
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.interactiveWithProgress) {
                self.interactiveWithProgress = NO;
                if (!_shouldComplate || panGes.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition]; // 取消此次转场
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
        }
            break;
        default:
            break;
    }
}

@end



