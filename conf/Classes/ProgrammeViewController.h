//
//  ProgrammeViewController.h
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDataSource.h"
#import "BaseViewController.h"
#import "HallSelector.h"

@interface ProgrammeViewController : BaseViewController <UITableViewDataSource, UITableViewDataSource, HallSelectorDataSource, HallSelectorDelegate>
{
    NSMutableArray * dataArray;
    IBOutlet HallSelector *selector;
    IBOutlet UITableView *table;
    BaseDataSource * _dataSource;
    
    NSString * selectedHall;
}

@end
