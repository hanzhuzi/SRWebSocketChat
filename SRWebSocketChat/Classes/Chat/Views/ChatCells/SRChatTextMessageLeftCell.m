//
//  SRChatTextMessageLeftCell.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/27.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

static const CGFloat HeaderImageViewHeight      = 45.0;
static const CGFloat HeaderImageViewToLeft     = 15.0;
static const CGFloat UserNameToHeaderImageView  = 10.0;
static const CGFloat timeToTopOffSet            = 10.0;
static const CGFloat TextLineSpace              = 2.0;

#import "SRChatTextMessageLeftCell.h"
#import "TTTAttributedLabel.h"
#import "SRChatTextMessage.h"

@interface SRChatTextMessageLeftCell ()<TTTAttributedLabelDelegate>

@end

@implementation SRChatTextMessageLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        __weak __typeof(self) weakSelf = self;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = ColorWithRGB(205, 205, 205);
        _timeLabel.font = TextSystemFontWithSize(12.0);
        _timeLabel.textColor = ColorWithRGB(250, 250, 250);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        
        // add constraints.
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(timeToTopOffSet);
            make.width.equalTo(@150.0);
            make.height.equalTo(@18.0);
            make.centerX.equalTo(weakSelf.contentView.mas_centerX).offset(0.0);
        }];
        
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 4.0;
        
        _headerImageView = [[UIImageView alloc] init];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:@"http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/88dbfc27jw8eup3rinaqrj20u00u00uc.jpg"] placeholderImage:nil options:SDWebImageDelayPlaceholder];
        [self.contentView addSubview:_headerImageView];

        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(HeaderImageViewToLeft));
            make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(10.0);
            make.width.height.equalTo(@(HeaderImageViewHeight));
        }];
        
        UIBezierPath * maskBezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, HeaderImageViewHeight, HeaderImageViewHeight) cornerRadius:HeaderImageViewHeight * 0.5];
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskBezierPath.CGPath;
        _headerImageView.layer.mask = maskLayer;
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = ColorWithRGB(118, 118, 118);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.font = TextSystemFontWithSize(12.0);
        [self.contentView addSubview:_userNameLabel];
        
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.headerImageView.mas_trailing).offset(UserNameToHeaderImageView);
            make.top.equalTo(weakSelf.headerImageView.mas_top).offset(0.0);
            make.width.equalTo(@(100.0));
            make.height.equalTo(@(18.0));
        }];
        
        _bubbleImageView = [[UIImageView alloc] init];
        _bubbleImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bubbleImageView];
        
        UIImage * boubbleImage = [UIImage imageNamed:@"chat_recive_nor"];
        CGSize bubbleImageSize = boubbleImage.size;
        boubbleImage = [boubbleImage stretchableImageWithLeftCapWidth:bubbleImageSize.width * 0.5 topCapHeight:bubbleImageSize.height * 0.6];
        _bubbleImageView.image = boubbleImage;
        
        [_bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.userNameLabel.mas_leading).offset(0.0);
            make.top.equalTo(weakSelf.userNameLabel.mas_bottom).offset(0.0);
            make.width.equalTo(@(200.0));
            make.height.equalTo(@(80.0));
        }];
        
        _textMessageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _textMessageLabel.textColor = ColorWithRGB(0, 0, 0);
        _textMessageLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        _textMessageLabel.font = SRChatTextFont;
        _textMessageLabel.numberOfLines = 0;
        _textMessageLabel.delegate = self;
        _textMessageLabel.userInteractionEnabled = YES;
        _textMessageLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
        // 更改AttributedLabel的链接样式
        NSMutableDictionary * linkeAttributes = [[NSMutableDictionary alloc] init];
        [linkeAttributes setValue:@YES forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [linkeAttributes setValue:(__bridge id)[UIColor blueColor].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
        _textMessageLabel.linkAttributes = linkeAttributes;
        [self.bubbleImageView addSubview:_textMessageLabel];
        
        [_textMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.bubbleImageView.mas_centerX).offset(0.0);
            make.centerY.equalTo(weakSelf.bubbleImageView.mas_centerY).offset(0.0);
            make.width.equalTo(@(0));
            make.height.equalTo(@(0));
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)configurationSRChatTextMessageLeftCellWithSRchatTextMessage:(SRChatTextMessage *)message
{
    if (message) {
        _timeLabel.text = message.time;
        _userNameLabel.text = message.from_client_name;
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = TextLineSpace;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary * attributes = @{NSFontAttributeName : SRChatTextFont, NSForegroundColorAttributeName : ColorWithRGB(0, 0, 0), NSParagraphStyleAttributeName : style};
        _textMessageLabel.text = message.textMessage;
        CGFloat bubbleMaxWidth = [UIScreen mainScreen].bounds.size.width - HeaderImageViewHeight * 2.0 - HeaderImageViewToLeft * 2.0 - UserNameToHeaderImageView;
        CGSize textSize = [message.textMessage calculateAttributesSizeWithConstrainedToSize:CGSizeMake(bubbleMaxWidth, MAXFLOAT) attributes:attributes lineSpace:style.lineSpacing];
        CGSize bubbleSize = CGSizeMake(textSize.width + 35.0, textSize.height + 35.0);
        
        __weak __typeof(self) weakSelf = self;
        [_bubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.userNameLabel.mas_leading).offset(0.0);
            make.top.equalTo(weakSelf.userNameLabel.mas_bottom).offset(0.0);
            make.width.equalTo(@(bubbleSize.width));
            make.height.equalTo(@(bubbleSize.height));
        }];
        
        [_textMessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.bubbleImageView.mas_centerX).offset(0.0);
            make.centerY.equalTo(weakSelf.bubbleImageView.mas_centerY).offset(0.0);
            make.width.equalTo(@(textSize.width));
            make.height.equalTo(@(textSize.height));
        }];
        
        NSLog(@"textSize: %@", NSStringFromCGSize(textSize));
    }
    else {
        
    }
}

+ (CGFloat)calculateSRChatTextMessageLeftCellHeightWithTextMessage:(SRChatTextMessage *)message
{
    CGFloat height = 0.0;
    height += timeToTopOffSet;
    height += 18.0; // time
    height += 10.0;
    height += 16.0;
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = TextLineSpace;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName : SRChatTextFont, NSForegroundColorAttributeName : ColorWithRGB(0, 0, 0), NSParagraphStyleAttributeName : style};
    CGFloat bubbleMaxWidth = [UIScreen mainScreen].bounds.size.width - HeaderImageViewHeight * 2.0 - HeaderImageViewToLeft * 2.0 - UserNameToHeaderImageView;
    CGSize textSize = [message.textMessage calculateAttributesSizeWithConstrainedToSize:CGSizeMake(bubbleMaxWidth, MAXFLOAT) attributes:attributes lineSpace:style.lineSpacing];
    CGSize bubbleSize = CGSizeMake(textSize.width + 35.0, textSize.height + 35.0);
    height += bubbleSize.height;
    height += 10.0;
    return height;
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
