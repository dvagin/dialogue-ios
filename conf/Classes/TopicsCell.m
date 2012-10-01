//
//  TopicsCell.m
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "TopicsCell.h"

@implementation TopicsCell
@synthesize textLabel;
@synthesize icon;
@synthesize bg;

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
