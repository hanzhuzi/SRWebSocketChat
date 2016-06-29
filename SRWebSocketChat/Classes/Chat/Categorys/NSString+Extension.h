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
 * @brief  计算富文本的size（适应UILabel的size）
 *
 * @param  lineSpace 行间距
 * @return UILabel的size
 */
- (CGSize)calculateAttributesSizeWithConstrainedToSize: (CGSize)size
                                            attributes:(NSDictionary *)attributes
                                             lineSpace: (CGFloat)lineSpace;
@end
