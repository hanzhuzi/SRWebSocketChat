//
//  TransitionData.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/25.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "XRMoveTransitionData.h"

@implementation XRMoveTransitionData

+ (instancetype)shareTransitionData
{
    static XRMoveTransitionData * data = nil;
    static dispatch_once_t onceToken = 0l;
    
    dispatch_once(&onceToken, ^{
        if (data == nil) {
            data = [[self alloc] init];
        }
    });
    return data;
}

@end
