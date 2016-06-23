//
//  SRChatUserInfo.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 * @brief 用户信息
 */

#import <Foundation/Foundation.h>

@interface SRChatUserInfo : NSObject
@property (nonatomic,   copy) NSString * req_type; // 请求类型
@property (nonatomic,   copy) NSString * userName; // 用户名
@property (nonatomic,   copy) NSString * passWord; // 用户密码
@property (nonatomic,   copy) NSString * room_id;  // 用户房间号
@property (nonatomic,   copy) NSString * client_id;
@property (nonatomic,   copy) NSString * client_name;
@property (nonatomic,   copy) NSString * time;
@property (nonatomic, strong) NSDictionary * client_list;

+ (instancetype)sharedUserInfo;
@end
