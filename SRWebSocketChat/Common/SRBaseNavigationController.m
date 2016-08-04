//
//  SRBaseNavigationController.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRBaseNavigationController.h"
#import "XRCicleTransitionAnimation.h"
#import "ViewController.h"
#import "SRChatViewController.h"

@interface SRBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation SRBaseNavigationController

- (void)setupNavigation
{
    // set navigationBar
    self.navigationBar.tintColor = ColorWithRGB(255, 255, 255);
    self.navigationBar.barTintColor = ColorWithRGB(220, 220, 220);
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : TextSystemFontWithSize(18.0), NSForegroundColorAttributeName : ColorWithRGB(255, 255, 255)};
    self.navigationBar.translucent = YES;
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigation];
}

#pragma mark - UINavigationControllerDelegate

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

@end
