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

+ (NSString *)getCurrentTimeStringFromDate
{
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

@end
