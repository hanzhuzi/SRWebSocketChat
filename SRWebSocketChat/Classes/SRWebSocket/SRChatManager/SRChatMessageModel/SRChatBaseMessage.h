//
//  SRChatBaseMessage.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import <Foundation/Foundation.h>

// 消息来源类型
typedef enum {
    SRChatMessageFromTypeMe = 1 << 0,
    SRChatMessageFromTypeOther = 1 << 1
}SRChatMessageFromType;

@interface SRChatBaseMessage : NSObject
@property (nonatomic, copy)   NSString * dateText;
@property (nonatomic, assign) SRChatMessageFromType msgFromType;
@end
