//
//  SRChatUserInfo.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRChatUserInfo.h"

@implementation SRChatUserInfo

+ (instancetype)sharedUserInfo
{
    static SRChatUserInfo * userInfo = nil;
    static dispatch_once_t onceToken = 0l;
    
    dispatch_once(&onceToken, ^{
        if (!userInfo) {
            userInfo = [[SRChatUserInfo alloc] init];
        }
    });
    return userInfo;
}

@end
