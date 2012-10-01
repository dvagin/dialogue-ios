//
//  HallCell.m
//  conf
//
//  Created by Владимир Малашенков on 01.10.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "HallCell.h"

@implementation HallCell

@synthesize timeLabel;
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
