//
//  NSString+Extension.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/27.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "NSString+Extension.h"
#import <CoreText/CoreText.h>

@implementation NSString (Extension)

- (BOOL)isEmpty
{
    return ([self isEqualToString:@""] && self.length == 0) ? YES : NO;
}

/** 计算文本的size以适应UILabel的size */
- (CGSize)calculateAttributesSizeWithConstrainedToSize:(CGSize)size
                                            attributes:(NSDictionary *)attributes
                                             lineSpace:(CGFloat)lineSpace
{
    if (!self || self.isEmpty) {
        return CGSizeZero;
    }
    
    /*
     NSStringDrawingUsesFontLeading 以字体间的行距来计算，计算时会加上行距.
     NSStringDrawingUsesLineFragmentOrigin 整个文本的将以每行组成的矩形为单位来计算文本的尺寸.
     NSStringDrawingTruncatesLastVisibleLine NSStringDrawingUsesDeviceMetrics 将以每个字为单位来计算文本的尺寸.
     */
    
    CGSize fitSize = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    fitSize.height += lineSpace;
    fitSize.width += 6.0; // Label的宽度要比文本的宽度长5~7px
    
    return fitSize;
}

@end
