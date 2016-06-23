//
//  UIView+Extension.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGSize)es_size
{
    return self.frame.size;
}

- (CGFloat)es_x
{
    return self.frame.origin.x;
}

- (CGFloat)es_y
{
    return self.frame.origin.y;
}

- (CGFloat)es_width
{
    return self.frame.size.width;
}

- (CGFloat)es_height
{
    return self.frame.size.height;
}

@end
