//
//  ProgrammCell.m
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "ProgrammCell.h"

@implementation ProgrammCell
@synthesize textLabel;
@synthesize bg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCellHeight:(CGFloat)height
{
    self.frame = CGRectMake(0, 0, self.frame.size.width, height);
    bg.frame = self.frame;
    textLabel.center = CGPointMake(textLabel.center.x, self.center.y);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
