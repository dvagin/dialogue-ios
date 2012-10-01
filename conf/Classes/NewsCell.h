//
//  NewsCell.h
//  conf
//
//  Created by Sergey Vishnyov on 9/27/12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* authorNameLabel;
@property (nonatomic, strong) IBOutlet UILabel* dateOfPublicationLabel;
@property (nonatomic, strong) IBOutlet UILabel* nameOfTopicLabel;


@end
