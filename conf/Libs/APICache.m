//
//  APICache.m
//  TSapp
//
//  Created by Alximik on 03.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APICache.h"

@implementation APICache

@synthesize cache;

static APICache* sharedAPICache = NULL;
+ (APICache*)sharedAPICache {
    if (!sharedAPICache || sharedAPICache == NULL) {
		sharedAPICache = [APICache new];
        sharedAPICache.cache = [[NSCache new] autorelease];
        
        [[NSNotificationCenter defaultCenter] addObserver:sharedAPICache 
                                                 selector:@selector(_didReceiveMemoryWarning) 
                                                     name:UIApplicationDidReceiveMemoryWarningNotification 
                                                   object:nil];
	}
	return sharedAPICache;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.cache = nil;
    [super dealloc];
}

- (void)_didReceiveMemoryWarning {
	[self removeAllObjects];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    if (![cache objectForKey:key] && object) {
        [cache setObject:object forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    return [cache objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [cache removeObjectForKey:key];
}

- (void)removeAllObjects {
    [cache removeAllObjects];
}

@end
