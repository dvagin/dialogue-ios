//
//  NewsViewController.h
//  conf
//
//  Created by Sergey Vishnyov on 9/27/12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCell.h"
#import "BaseDataSource.h"
#import "DataManager.h"
#import "BaseViewController.h"

@interface NewsViewController : BaseViewController 
{
    BaseDataSource * _dataSource;
    IBOutlet UITableView *table;
    rssDataType currentType;
}

@property (nonatomic) NSArray* arrayOfNews;

- (id) initWithRssType:(rssDataType)type;

@end
