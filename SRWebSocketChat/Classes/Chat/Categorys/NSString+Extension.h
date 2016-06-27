//
//  NSString+Extension.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/27.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 * @brief   判断字符串是否是空串
 *
 * @param
 *
 * @return  YES or NO
 */
- (BOOL)isEmpty;

/**
 * @brief   将当前时间转为时间字符串
 *
 * @return  时间格式化字符串 (格式：2016-06-22 16:15:36)
 */
+ (NSString *)getCurrentTimeStringFromDate;

@end
