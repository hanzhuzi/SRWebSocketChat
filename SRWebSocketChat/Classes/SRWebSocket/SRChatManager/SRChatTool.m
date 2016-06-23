//
//  RSChatTool.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRChatTool.h"

@implementation SRChatTool

+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }
    else {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

+ (NSDictionary *)dictionaryFromJSONString:(NSString *)jsonString
{
    if (!jsonString) {
        return nil;
    }
    else {
        NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:nil];
        return dict;
    }
}

@end
