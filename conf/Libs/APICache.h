//
//  APICache.h
//  TSapp
//
//  Created by Alximik on 03.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APICache : NSObject

@property (nonatomic, retain) NSCache *cache;

+ (APICache*)sharedAPICache;

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;

@end
