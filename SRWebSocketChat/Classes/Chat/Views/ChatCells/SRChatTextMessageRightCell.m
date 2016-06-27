//
//  SRChatTextMessageRightCell.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/27.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

static const CGFloat HeaderImageViewHeight = 45.0;

#import "SRChatTextMessageRightCell.h"
#import "TTTAttributedLabel.h"

@interface SRChatTextMessageRightCell ()<TTTAttributedLabelDelegate>

@end

@implementation SRChatTextMessageRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        __weak __typeof(self) weakSelf = self;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = ColorWithRGB(205, 205, 205);
        _timeLabel.font = TextSystemFontWithSize(12.0);
        _timeLabel.text = @"15:22:02";
        _timeLabel.textColor = ColorWithRGB(250, 250, 250);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        
        // add constraints.
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10.0);
            make.width.equalTo(@100.0);
            make.height.equalTo(@18.0);
            make.centerX.equalTo(weakSelf.contentView.mas_centerX).offset(0.0);
        }];
        
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 4.0;
        
        _headerImageView = [[UIImageView alloc] init];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:@"http://p3.music.126.net/TpaiKUmfb-p6caV4DF4-rg==/1393081234257218.jpg"] placeholderImage:nil options:SDWebImageDelayPlaceholder];
        [self.contentView addSubview:_headerImageView];
        
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@(-15.0));
            make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(10.0);
            make.width.height.equalTo(@(HeaderImageViewHeight));
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = ColorWithRGB(118, 118, 118);
        _userNameLabel.textAlignment = NSTextAlignmentRight;
        _userNameLabel.font = TextSystemFontWithSize(12.0);
        _userNameLabel.text = @"笑看茶凉";
        [self.contentView addSubview:_userNameLabel];
        
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.headerImageView.mas_leading).offset(-10.0);
            make.top.equalTo(weakSelf.headerImageView.mas_top).offset(0.0);
            make.width.equalTo(@(100.0));
            make.height.equalTo(@(18.0));
        }];
        
        _bubbleImageView = [[UIImageView alloc] init];
        _bubbleImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bubbleImageView];
        
        UIImage * boubbleImage = [UIImage imageNamed:@"srchat_boubble_outgoing"];
        CGSize bubbleImageSize = boubbleImage.size;
        boubbleImage = [boubbleImage stretchableImageWithLeftCapWidth:bubbleImageSize.width * 0.5 topCapHeight:bubbleImageSize.height * 0.5 + 8.0];
        _bubbleImageView.image = boubbleImage;
        
        [_bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.userNameLabel.mas_trailing).offset(0.0);
            make.top.equalTo(weakSelf.userNameLabel.mas_bottom).offset(5.0);
            make.width.equalTo(@(200.0));
            make.height.equalTo(@(80.0));
        }];
        
        _textMessageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _textMessageLabel.backgroundColor = [UIColor clearColor];
        _textMessageLabel.textColor = ColorWithRGB(0, 0, 0);
        _textMessageLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        _textMessageLabel.font = TextSystemFontWithSize(13.0);
        _textMessageLabel.numberOfLines = 0;
        _textMessageLabel.delegate = self;
        _textMessageLabel.userInteractionEnabled = YES;
        _textMessageLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
        // 更改AttributedLabel的链接样式
        NSMutableDictionary * linkeAttributes = [[NSMutableDictionary alloc] init];
        [linkeAttributes setValue:@YES forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [linkeAttributes setValue:(__bridge id)[UIColor redColor].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
        _textMessageLabel.linkAttributes = linkeAttributes;
        _textMessageLabel.text = @"10010自富阳至桐庐一百许里http://www.baidu.com 千百成峰。泉水激石，泠泠作响；好鸟相鸣，嘤嘤成韵。";
        [self.bubbleImageView addSubview:_textMessageLabel];
        
        [_textMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.bubbleImageView.mas_leading).offset(5.0);
            make.trailing.equalTo(weakSelf.bubbleImageView.mas_trailing).offset(-13.0);
            make.top.equalTo(weakSelf.bubbleImageView.mas_top).offset(3.0);
            make.bottom.equalTo(weakSelf.bubbleImageView.mas_bottom).offset(-3.0);
        }];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    if (![phoneNumber isEmpty]) {
        UIWebView * callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL * callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:callURL]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
