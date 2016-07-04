//
//  SRWebSocketConfig.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/24.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#ifndef SRWebSocketConfig_h
#define SRWebSocketConfig_h

#define ColorWithRGB(r, g, b)           [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define ColorWithHexRGB(hex)            [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.0\
green:((hex & 0xFF00) >> 8) / 255.0\
blue:(hex & 0xFF) / 255.0 alpha:1.0]

#define TextSystemFontWithSize(size)    [UIFont systemFontOfSize:(size)]
#define SRChatTextFont                  TextSystemFontWithSize(15.0)

// const define.
static CGFloat const SRChatButtonWH       =  50.0; // 聊天按钮大小
static CGFloat const SRChatButtonMoveTime = 1.0; // 聊天按钮移动时间
static CGFloat const SRChatViewMovingTime = 1.0; // 进入聊天页面时间

#endif /* SRWebSocketConfig_h */
