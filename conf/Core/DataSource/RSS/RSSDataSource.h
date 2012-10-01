//
//  RSSDataSource.h
//  conf
//
//  Created by VS on 29.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "BaseDataSource.h"
#import "DataManager.h"

@interface RSSDataSource : BaseDataSource
{
    NSString * selectedMethod;
    int selectedType;
}

- (id)initWithType:(rssDataType)type;
- (NSArray*) mainItems;

- (NSString*) authorAtIndex:(NSInteger)index;
- (NSString*) htmlBodyAtIndex:(NSInteger)index;
- (NSString*) publicDateAtIndex:(NSInteger)index;
- (NSString*) titleAtIndex:(NSInteger)index;
- (NSString*) linkAtIndex:(NSInteger)index;

@end
