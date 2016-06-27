//
//  SRChatTextMessageRightCell.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/27.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRChatBaseCell.h"

@class TTTAttributedLabel;
@interface SRChatTextMessageRightCell : SRChatBaseCell

@property (nonatomic, strong) UIImageView * headerImageView; // 头像
@property (nonatomic, strong) UILabel * userNameLabel;       // 昵称
@property (nonatomic, strong) TTTAttributedLabel * textMessageLabel; // 消息
@property (nonatomic, strong) UIImageView * bubbleImageView; // 气泡
@property (nonatomic, strong) UILabel * timeLabel; // 时间

@end
