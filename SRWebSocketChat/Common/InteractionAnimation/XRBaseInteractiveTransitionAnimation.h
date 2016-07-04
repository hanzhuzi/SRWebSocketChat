//
//  XRBaseInteractiveTransitionAnimation.h
//  SRWebSocketChat
//
//  Created by xuran on 16/7/4.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 手势交互
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XRInteractiveOperation) {
    XRInteractiveOperationPop     = 1 << 1,
    XRInteractiveOperationDismiss = 1 << 2,
    XRInteractiveOperationTab     = 1 << 3
};

@interface XRBaseInteractiveTransitionAnimation : UIPercentDrivenInteractiveTransition

/**
 是否开启进度驱动
 */
@property (nonatomic, assign) BOOL interactiveWithProgress;
@property (nonatomic, assign) XRInteractiveOperation operation;

/**
 关联某个UIViewController进行手势交互
 */
- (void)wireToViewController:(UIViewController *)viewController withOperation:(XRInteractiveOperation)opt;

@end
