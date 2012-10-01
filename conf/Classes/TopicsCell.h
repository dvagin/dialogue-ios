//
//  TopicsCell.h
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicsCell : UITableViewCell


@property (nonatomic,strong) IBOutlet UILabel * textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UIImageView *bg;

@end
