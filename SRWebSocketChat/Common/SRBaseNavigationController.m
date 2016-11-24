//
//  SRBaseNavigationController.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRBaseNavigationController.h"
#import "XRCicleTransitionAnimation.h"
#import "XRTranslateTransitionAnimation.h"
#import "ViewController.h"
#import "SRChatViewController.h"
#import "XRVerticalInteractiveTransitionAnimation.h"
#import "CEFlipAnimationController.h"
#import "XRFadeTransitionAnimation.h"

@interface SRBaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) XRVerticalInteractiveTransitionAnimation * interactiveTransitionAnimator;
@property (nonatomic, strong) UIViewController * currentViewCtrl;
@end

@implementation SRBaseNavigationController

- (void)setupNavigationBar
{
    // set navigationBar
    self.navigationBar.tintColor = ColorWithRGB(255, 255, 255);
    self.navigationBar.barTintColor = ColorWithRGB(160, 160, 160);
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : TextSystemFontWithSize(18.0), NSForegroundColorAttributeName : ColorWithRGB(255, 255, 255)};
    self.navigationBar.translucent = YES;
    self.delegate = self;
//    self.interactivePopGestureRecognizer.delegate = self;
    self.interactiveTransitionAnimator = [[XRVerticalInteractiveTransitionAnimation alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    
//    if ([self.currentViewCtrl isKindOfClass:[SRChatViewController class]]) {
//        return NO;
//    }
//    return YES;
//}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self wirePopInteractionControllerTo:viewController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    self.currentViewCtrl = viewController;
}

- (void)wirePopInteractionControllerTo:(UIViewController *)viewController
{
    // when a push occurs, wire the interaction controller to the to- view controller
    if (!self.interactiveTransitionAnimator) {
        return;
    }
    
    [self.interactiveTransitionAnimator wireToViewController:viewController withOperation:XRInteractiveOperationPop];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([fromVC isKindOfClass:[ViewController class]] && [toVC isKindOfClass:[SRChatViewController class]]) {
        XRCicleTransitionAnimation * cicleAnimator = [[XRCicleTransitionAnimation alloc] init];
        cicleAnimator.reverse = NO;
        return cicleAnimator;
    }
    else if ([fromVC isKindOfClass:[SRChatViewController class]] && [toVC isKindOfClass:[ViewController class]]) {
        XRCicleTransitionAnimation * cicleAnimator = [[XRCicleTransitionAnimation alloc] init];
        cicleAnimator.reverse = YES;
        return cicleAnimator;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransitionAnimator && self.interactiveTransitionAnimator.interactiveWithProgress ? self.interactiveTransitionAnimator : nil;
}

@end
