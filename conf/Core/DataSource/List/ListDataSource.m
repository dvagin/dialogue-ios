//
//  ListDataSource.m
//  conf
//
//  Created by админ on 28.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "ListDataSource.h"

@implementation ListDataSource

- (NSDictionary*)mainDict
{
    return (NSDictionary*)[self getObjectForKey:@"main"];
}

- (NSArray*)hallsList
{
    return (NSArray*)[self getObjectForKey:@"keys"];
}

- (NSArray*)daysForHallName:(NSString*)hallName
{
    NSArray * daysArray = [[self mainDict] objectForKey:hallName];
    if (daysArray.count)
    {
        NSMutableArray * finalArray = [NSMutableArray array];
        
        for (NSDictionary * oneDict in daysArray)
        {
            if ([oneDict objectForKey:@"Date"])
            {
                if (![[oneDict objectForKey:@"Date"] isKindOfClass:[NSString class]])
                    [finalArray addObject: [oneDict objectForKey:@"value"]];
            }
        }
        
        return finalArray;
    }
    else 
        return nil;
}

- (NSArray*)dataForHallName:(NSString*)hallName
{
    NSArray * daysArray = [[self mainDict] objectForKey:hallName];
    if (daysArray.count)
    {
        NSMutableArray * finalArray = [NSMutableArray array];
        
        for (NSDictionary * oneDict in daysArray)
        {
            if ([oneDict objectForKey:@"Date"])
            {
                if (![[oneDict objectForKey:@"Date"] isKindOfClass:[NSString class]])
                    [finalArray addObject: oneDict];
            }
        }
        
        return finalArray;
    }
    else 
        return nil;
}


#pragma mark -
#pragma mark BaseDataSource members


- (void) fillRequestBody:(ServerRequest*)request
{
    //request.apiMethod = kApiMethodGetList;
    request.apiMethod = kApiMethodGetList;
}

- (BOOL) processResponseBody:(ServerResponse *)responce
{
    //main data
    [self setObject:responce.body forKey:@"main"];
    [self setObject:[[self mainDict] allKeys] forKey:@"keys"];
//   NSLog(@"%@",[self mainDict]);
    
    return YES;
}

@end
