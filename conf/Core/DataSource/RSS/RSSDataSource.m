//
//  RSSDataSource.m
//  conf
//
//  Created by VS on 29.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "RSSDataSource.h"


@implementation RSSDataSource

- (id)initWithType:(rssDataType)type
{
    self = [super init];
    if (self) {
        
        selectedType = type;
        
        switch (type) {
            case rssDataTypeSociety:
                selectedMethod = @"index.php?option=com_content&view=category&layout=blog&id=68&Itemid=94&lang=en&format=feed&type=rss";
                break;
            case rssDataTypeNews:
                selectedMethod = @"index.php?format=feed&type=rss&lang=en";
                break;
            case rssDataTypePolitics:
                selectedMethod = @"index.php?option=com_content&view=category&layout=blog&id=40&Itemid=93&lang=en&format=feed&type=rss";
                break;
            case rssDataTypeEconomics:
                selectedMethod = @"index.php?option=com_content&view=category&layout=blog&id=41&Itemid=92&lang=en&format=feed&type=rss";
                break;
            case rssDataTypeEvents:
                selectedMethod = @"index.php?option=com_content&view=category&layout=blog&id=16&Itemid=95&lang=en&format=feed&type=rss";
                break;

                
            default:
                break;
        }
    }
    return self;
}

- (NSArray*) mainItems
{
    return (NSArray*)[self getObjectForKey:[NSString stringWithFormat:@"mainItems%i", selectedType]];
}

- (NSDictionary*)mainDict
{
    return (NSDictionary*)[self getObjectForKey:[NSString stringWithFormat:@"main%i", selectedType]];
}

- (NSArray*)hallsList
{
    return [[self mainDict] allKeys];
}

- (NSString*) authorAtIndex:(NSInteger)index
{
    NSString * authorFull = [[[[[self mainItems] objectAtIndex:index] objectForKey:@"item"]objectForKey:@"author"] objectForKey:@"author"];
    
    NSRange firstRange = [authorFull rangeOfString:@"("];
    NSRange secondRange = [authorFull rangeOfString:@")"];
   
    NSRange range = NSMakeRange(firstRange.location + 1, secondRange.location - firstRange.location - 1);
    
    if (firstRange.location != NSNotFound && secondRange.location != NSNotFound) 
    {
        // String was found
        return [authorFull substringWithRange:range];
        
    }
    else 
    {
        // String not found
        return authorFull;
    }
}

- (NSString*) htmlBodyAtIndex:(NSInteger)index
{
    return [[[[[self mainItems] objectAtIndex:index] objectForKey:@"item"]objectForKey:@"description"] objectForKey:@"description"];
}

- (NSString*) linkAtIndex:(NSInteger)index
{
    return [[[[[self mainItems] objectAtIndex:index] objectForKey:@"item"]objectForKey:@"link"] objectForKey:@"link"];
}

- (NSString*) titleAtIndex:(NSInteger)index
{
    return [[[[[self mainItems] objectAtIndex:index] objectForKey:@"item"]objectForKey:@"title"] objectForKey:@"title"];
}

- (NSString*) publicDateAtIndex:(NSInteger)index
{
    NSString * dateString = [[[[[self mainItems] objectAtIndex:index] objectForKey:@"item"]objectForKey:@"pubDate"] objectForKey:@"pubDate"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];

    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
    NSDate *dateFromString = [[NSDate alloc] init];
    
    dateFromString = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    
    NSString * newDateString = [dateFormatter stringFromDate:dateFromString];
    
     return newDateString;  
}

- (void) formItems
{
    NSArray * mainArray = [[self mainDict] objectForKey:@"channel"];
    
    if (mainArray.count)
    {
        NSMutableArray * newArray = [NSMutableArray array];
        for (NSDictionary * oneDict in mainArray)
        {
            if ([oneDict objectForKey:@"item"])
            {
                [newArray addObject: oneDict];
            }
        }
        
        [self setObject:newArray forKey:[NSString stringWithFormat:@"mainItems%i", selectedType]];
    }
}

#pragma mark -
#pragma mark BaseDataSource members


- (void) fillRequestBody:(ServerRequest*)request
{
    //request.apiMethod = kApiMethodGetList;
    request.apiURL = @"http://wpfdc.org";
    
    request.apiMethod = selectedMethod;
}

- (BOOL) processResponseBody:(ServerResponse *)responce
{
    //main data
    [self setObject:responce.body forKey:[NSString stringWithFormat:@"main%i", selectedType]];
    
    [self formItems];
//    NSLog(@"%@",[self mainItems]);
    
    return YES;
}

@end
