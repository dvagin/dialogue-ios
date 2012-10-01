//
//  ListDataSource.h
//  conf
//
//  Created by админ on 28.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "BaseDataSource.h"

@interface ListDataSource : BaseDataSource


- (NSArray*)hallsList;
- (NSArray*)daysForHallName:(NSString*)hallName;
- (NSArray*)dataForHallName:(NSString*)hallName;

@end
