//
//  SRChatBaseMessage.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRChatBaseMessage : NSObject
@property (nonatomic, copy)   NSString * req_type;
@property (nonatomic, copy)   NSString * from_client_id;
@property (nonatomic, copy)   NSString * from_client_name;
@property (nonatomic, copy)   NSString * to_client_id;
@property (nonatomic, copy)   NSString * time;
@property (nonatomic, assign) SRChatMessageFromType msgFromType;
@property (nonatomic, assign) SRChatMessageSendStatus status;
@property (nonatomic, assign) CGFloat heightForCell;
@end
