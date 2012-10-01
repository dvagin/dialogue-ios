//
//  ProgrammCell.h
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgrammCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bg;

- (void)setCellHeight:(CGFloat)height;
@end
