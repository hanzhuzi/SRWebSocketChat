//
//  SRChatTextMessage.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRChatBaseMessage.h"

@interface SRChatTextMessage : SRChatBaseMessage
@property (nonatomic, copy) NSString * textMessage; // 文本消息
@end
