//
//  SRChatConfig.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#ifndef SRChatConfig_h
#define SRChatConfig_h

#define SRWEBSOCKET_URL                 @"ws://10.26.52.130:7272"
#define SRWEBSOCKET_PONGTIMERINTERVAL   20.0 // 服务器心跳时间间隔
#define SRWEBSOCKET_TIMEOUTMAXCOUNT     5    // 最大允许超时次数

// 消息发送的状态
typedef NS_ENUM(NSInteger, SRChatMessageSendStatus) {
    SRChatMessageSendStatusSending = 1 << 1,         // 发送中
    SRChatMessageSendStatusSendSuccessful = 1 << 2,  // 发送成功
    SRChatMessageSendStatusSendFailed     = 1 << 3   // 发送失败
};

// 消息来源类型
typedef NS_ENUM(NSInteger, SRChatMessageFromType) {
    SRChatMessageFromTypeMe = 1 << 1, // 自己发送的消息 to all.
    SRChatMessageFromTypeOther = 1 << 2, // 其他人发送的消息 from all.
    SRChatMessageFromTypeSystem = 1 << 3 // 系统消息 from system.
};

#endif /* SRChatConfig_h */
