//
//  SRChatInputToolBar.h
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 * @brief  聊天发送消息工具条
 *
 * @by     黯丶野火
 */
/** 工具条最小的高度 */
static const CGFloat InputToolBarMinHeight = 46.0;

#import <UIKit/UIKit.h>

@class SRChatInputToolBar;
@protocol SRChatInputToolBarDelegate <NSObject>

@optional

// 返回当前输入框内容改变后inputBar的高度
- (void)chatInputToolBar:(SRChatInputToolBar *)inputToolBar didReciveBarHeightChanged:(CGFloat)barHeight;

@end

@interface SRChatInputToolBar : UIView

@property (nonatomic, weak) id<SRChatInputToolBarDelegate> delegate;

/**
 * @brief 设置toolBar的frame
 * 
 * @param 需要设置的frame
 * @param 是否需要动画
 *
 * @return
 */
- (void)setFrame:(CGRect)frame animated:(BOOL)animated;

@end
