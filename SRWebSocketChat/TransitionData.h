//
//  TransitionData.h
//  SRWebSocketChat
//
//  Created by xuran on 16/7/25.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitionData : NSObject

@property (nonatomic, strong) UIImageView * animateImageView;
@property (nonatomic, strong) UIImage * animateImage;
@property (nonatomic, assign) CGRect    fromRect;
@property (nonatomic, assign) CGRect    toRect;

+ (instancetype)shareTransitionData;

@end
