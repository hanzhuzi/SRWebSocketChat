//
//  XRBaseInteractiveTransitionAnimation.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/4.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "XRBaseInteractiveTransitionAnimation.h"

@implementation XRBaseInteractiveTransitionAnimation

- (void)wireToViewController:(UIViewController *)viewController withOperation:(XRInteractiveOperation)opt
{
    // 抛出异常提示，必须重写这个方法.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"必须在子类中重写'%@'!", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
