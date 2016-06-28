//
//  SRChatViewController.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRBaseVieController.h"

@interface SRChatViewController : SRBaseVieController

/**
 * @brief   进入聊天室 指定聊天室id
 *
 * @param    聊天室id
 *
 * @return   聊天室
 */
+ (instancetype)chatViewControllerWithRoomID:(NSString *)roomId;

@end
