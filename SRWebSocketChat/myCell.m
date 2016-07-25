//
//  myCell.m
//  SRWebSocketChat
//
//  Created by xuran on 16/7/18.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "myCell.h"

@implementation myCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.myImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.myImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.myImageView.image = [UIImage imageNamed:@"header.jpeg"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
