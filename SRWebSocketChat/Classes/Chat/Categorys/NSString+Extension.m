//
//  NSString+Extension.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/27.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)isEmpty
{
    return ([self isEqualToString:@""] && self.length == 0) ? YES : NO;
}

@end
