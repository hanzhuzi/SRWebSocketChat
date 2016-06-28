//
//  SRChatManager.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 * @brief 聊天管理类
 * 
 * @by    黯丶野火
 */

#import <Foundation/Foundation.h>

// 聊天状态
typedef NS_ENUM(NSInteger, SRChatManagerStatus) {
    SRChatManagerStatusOpen           = 1 << 1,  // 与服务器连接成功
    SRChatManagerStatusClose          = 1 << 2,  // 与服务器断开连接
    SRChatManagerStatusLogin          = 1 << 3,  // 已登录
    SRChatManagerStatusLogOffByServer = 1 << 4,  // 已下线
    SRChatManagerStatusLogOffByUser   = 1 << 5 // 用户自己下线
};

@class SRChatManager;
@class SRChatUserInfo;
@class SRChatTextMessage;
@protocol SRChatManagerDelegate <NSObject>

@optional
// 与服务器连接状态变化回调
- (void)chatManager:(SRChatManager *)chatManager didReciveChatStatusChanged:(SRChatManagerStatus)status;
// 发送文本消息回调
- (void)chatManager:(SRChatManager *)chatManager didSendNewMessage:(SRChatTextMessage *)textMessage;
// 收到消息回调<文本消息，语音消息，图片消息，视频消息，系统消息...>
- (void)chatManager:(SRChatManager *)chatManager didReciveNewMessage:(SRChatTextMessage *)textMessage;
@end

@interface SRChatManager : NSObject

@property (nonatomic, strong) SRChatUserInfo * userInfo;
@property (nonatomic, assign) SRChatManagerStatus status;
@property (nonatomic, strong) NSMutableArray <SRChatTextMessage *> * chatMessages;
@property (nonatomic, assign) id<SRChatManagerDelegate> delegate;

/**
 * @brief   聊天管理类对象
 *
 * @return  SRChatManager
 */
+ (instancetype)defaultManager;

/**
 * @brief   建立连接
 *
 * @return
 */
- (void)openServer;

/**
 * @brief   关闭连接
 *
 * @return
 */
- (void)closeServer;

/**
 * @brief   发送文本消息
 *
 * @param   文本消息
 *
 * @return
 */
- (void)sendMessage:(NSString *)message;

@end
