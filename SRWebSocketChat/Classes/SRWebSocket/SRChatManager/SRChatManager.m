//
//  SRChatManager.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRChatManager.h"
#import "SocketRocket.h"
#import "SRChatTextMessage.h"
#import "SRChatConfig.h"
#import "SRChatTool.h"
#import "SRChatUserInfo.h"

static NSInteger secconds = 0;
static NSInteger timeoutCount = 0;

@interface SRChatManager ()<SRWebSocketDelegate>
{
    SRWebSocket * webSocket;
    NSTimer * countTimer;
}

@end

@implementation SRChatManager

- (void)dealloc
{
    if (countTimer) {
        [countTimer invalidate];
        countTimer = nil;
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        _status = SRChatManagerStatusClose;
        _chatMessages = [NSMutableArray arrayWithCapacity:10];
        _userInfo = [SRChatUserInfo sharedUserInfo];
    }
    return self;
}

+ (instancetype)defaultManager
{
    static SRChatManager * manager = nil;
    static dispatch_once_t onceToken = 0l;
    
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[SRChatManager alloc] init];
        }
    });
    
    return manager;
}

// 建立连接
- (void)openServer
{
    webSocket.delegate = nil;
    [webSocket close];
    
    webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:SRWEBSOCKET_URL]];
    webSocket.delegate = self;
    [webSocket open];
}

// 关闭连接
- (void)closeServer
{
    webSocket.delegate = nil;
    [webSocket close];
    webSocket = nil;
}

// 登录服务器
- (void)loginChatServer
{
    NSDictionary * loginInfo = @{
                                 @"type" : _userInfo.req_type ? _userInfo.req_type : @"",
                                 @"client_name" : _userInfo.userName ? _userInfo.userName : @"",
                                 @"room_id" : _userInfo.room_id ? _userInfo.room_id : @""
                                 };
    NSString * jsonString = [SRChatTool jsonStringFromDictionary:loginInfo];
    [webSocket sendString:jsonString];
}

// 发送消息
- (void)sendMessage:(NSString *)message
{
    if (_status != SRChatManagerStatusLogin) {
        return;
    }
    NSLog(@"消息发送中...");
    
    NSDictionary * messageInfo = @{
                                   @"type" : @"say",
                                   @"from_client_id" : _userInfo.client_id,
                                   @"from_client_name" : _userInfo.client_name,
                                   @"to_client_id" : @"all",
                                   @"content" : message,
                                   @"time" : [SRChatTool getCurrentTimeStringFromDate]
                                   };
    NSString * jsonString = [SRChatTool jsonStringFromDictionary:messageInfo];
    [webSocket sendString:jsonString];

    SRChatTextMessage * textMsg = [[SRChatTextMessage alloc] init];
    textMsg.req_type = @"say";
    textMsg.from_client_id = _userInfo.client_id;
    textMsg.from_client_name = _userInfo.client_name;
    textMsg.to_client_id = @"all";
    textMsg.textMessage = message;
    textMsg.time = [SRChatTool getCurrentTimeStringFromDate];
    textMsg.msgFromType = SRChatMessageFromTypeMe;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didSendNewMessage:)]) {
        [self.delegate chatManager:self didSendNewMessage:textMsg];
    }
}

// 心跳回传
- (void)heartBeatPassBack
{
    NSDictionary * checkInfo = @{
                                 @"type" : @"pong"
                                 };
    NSString * jsonString = [SRChatTool jsonStringFromDictionary:checkInfo];
    if (_status == SRChatManagerStatusOpen) {
        [webSocket sendString:jsonString];
    }
}

// 开始计时
- (void)updateTimerCount
{
    if (secconds > SRWEBSOCKET_PONGTIMERINTERVAL) {
        // 根据服务器设置的超时时间定
        // SRWEBSOCKET_PONGTIMERINTERVAL时间间隔未收到心跳，则认定服务器端无响应.
        NSLog(@"心跳超时");
        secconds = 0;
        if (timeoutCount > SRWEBSOCKET_TIMEOUTMAXCOUNT) {
            // 超时次数大于SRWEBSOCKET_TIMEOUTMAXCOUNT表示连接失败
            timeoutCount = 0;
            [self closeServer];
            [self stopTimer];
            NSLog(@"断开与服务器的连接");
        }
        else {
            // 尝试重连
            NSLog(@"正在尝试重连... time(%d)", timeoutCount);
            if (_status == SRChatManagerStatusLogOffByUser) {
                // 若用户手动下线，则不重连.
                timeoutCount = 0;
                [self closeServer];
                [self stopTimer];
                NSLog(@"断开与服务器的连接");
            }
            else {
                [self openServer];
                ++timeoutCount; // 超时次数累计
            }
        }
    }
    else {
        ++secconds;
    }
}

// 停止计时
- (void)stopTimer
{
    if (countTimer) {
        [countTimer invalidate];
        countTimer = nil;
        secconds = 0; // 清零计数
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"连接已关闭， reason: %@ clean: %d", reason, wasClean);
    [self closeServer];
    _status = SRChatManagerStatusLogOffByServer;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didReciveChatStatusChanged:)]) {
        [self.delegate chatManager:self didReciveChatStatusChanged:_status];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error.localizedDescription);
    if (error) {
        // 连接出现错误
        [self closeServer];
        _status = SRChatManagerStatusClose;
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didReciveChatStatusChanged:)]) {
            [self.delegate chatManager:self didReciveChatStatusChanged:_status];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithData:(NSData *)data
{
    NSLog(@"rev data message: %@", data);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string
{
    if (string && string.length > 0) {
        NSDictionary * dict = [SRChatTool dictionaryFromJSONString:string];
        NSString * type = dict[@"type"];
        if ([type isEqualToString:@"login"]) {
            if (_status != SRChatManagerStatusLogin) {
                // 收到登录成功的消息
                _status = SRChatManagerStatusLogin;
                _userInfo.client_id = dict[@"client_id"];
                _userInfo.client_name = dict[@"client_name"];
                _userInfo.client_list = dict[@"client_list"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didReciveChatStatusChanged:)]) {
                    [self.delegate chatManager:self didReciveChatStatusChanged:_status];
                }
            }
        }
        else if ([type isEqualToString:@"say"]) {
            // 收到消息
            if (![dict[@"from_client_name"] isEqualToString:_userInfo.client_name]) {
                SRChatTextMessage * textMsg = [[SRChatTextMessage alloc] init];
#warning 这里等后台数据确定了可以优化，将数据解析封装到SRChatTextMessage
                textMsg.req_type = @"say";
                textMsg.from_client_id = dict[@"from_client_id"];
                textMsg.from_client_name = dict[@"from_client_name"];
                textMsg.to_client_id = @"all";
                textMsg.textMessage = dict[@"content"];
                textMsg.time = dict[@"time"];
                textMsg.msgFromType = SRChatMessageFromTypeOther;
                if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didReciveNewMessage:)]) {
                    [self.delegate chatManager:self didReciveNewMessage:textMsg];
                }
            }
            
            NSLog(@"收到一条消息: '%@' from '%@'", dict[@"content"], dict[@"from_client_name"]);
        }
        else if ([type isEqualToString:@"ping"]) {
            // 收到服务端心跳
            [self stopTimer];
            [self heartBeatPassBack]; // 回传心跳响应，告诉服务器还活着.
            // 开启计时定时器
            if (!countTimer) {
                countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerCount) userInfo:nil repeats:YES];
                [countTimer setFireDate:[NSDate distantPast]];
            }
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongData
{
    NSLog(@"rev pong data: %@", pongData);
}

- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket
{
    return YES;
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"建立连接成功");
    _status = SRChatManagerStatusOpen;
    [self loginChatServer]; // 登录服务器
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didReciveChatStatusChanged:)]) {
        [self.delegate chatManager:self didReciveChatStatusChanged:_status];
    }
}

@end




