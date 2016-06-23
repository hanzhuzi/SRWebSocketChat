//
//  SRChatInputToolBar.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRChatInputToolBar.h"

@interface SRChatInputToolBar ()
@property (nonatomic, strong) UITextField * inputTextField;
@end

@implementation SRChatInputToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(50.0, 5.0, self.es_width - 80.0, self.es_height - 10.0)];
        
        [self addSubview:_inputTextField];
    }
    return self;
}

@end
