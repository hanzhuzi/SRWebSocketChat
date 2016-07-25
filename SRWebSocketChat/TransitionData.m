//
//  TransitionData.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/25.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "TransitionData.h"

@implementation TransitionData

+ (instancetype)shareTransitionData
{
    static TransitionData * data = nil;
    static dispatch_once_t onceToken = 0l;
    
    dispatch_once(&onceToken, ^{
        if (data == nil) {
            data = [[TransitionData alloc] init];
        }
    });
    return data;
}

@end
