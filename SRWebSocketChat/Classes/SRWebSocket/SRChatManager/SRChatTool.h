//
//  SRChatTool.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 * @brief 聊天工具类
 */

#import <Foundation/Foundation.h>

@interface SRChatTool : NSObject

/**
 * @brief  字典转JSON字符串
 * 
 * @param  待转换的字典对象
 *
 * @return JSON字符串
 */
+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary;

/**
 * @brief   JSON字符串转字典对象
 *
 * @param   JSON字符串
 *
 * @return  字典对象
 */
+ (NSDictionary *)dictionaryFromJSONString:(NSString *)jsonString;

/**
 * @brief   将当前时间转为时间字符串
 *
 * @return  时间格式化字符串 (格式：2016-06-22 16:15:36)
 */
+ (NSString *)getCurrentTimeStringFromDate;

@end
