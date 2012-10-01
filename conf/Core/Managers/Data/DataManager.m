//
//  DataManager.m


#import "DataManager.h"
#import "RSSDataSource.h"

static DataManager* __defaultDataManager = nil;

@implementation DataManager

+ (DataManager*) defaultManager
{
    @synchronized (self)
    {
        if (!__defaultDataManager)
            __defaultDataManager = [DataManager new];
    }
    
    return __defaultDataManager;
}

- (id)init
{
    if (self = [super init])
    {
        _dataSources = [NSMutableDictionary new];
        _lock = [NSLock new];
    }
    
    return self;
}

- (id) retain { return self; }
- (oneway void) release {}
- (NSUInteger) retainCount { return UINT_MAX; }

- (void) dispose
{
    for (BaseDataSource* dataSource in [_dataSources allValues])
        [dataSource storeState];
    
    [_dataSources release];
    _dataSources = nil;
    
    [_lock release];
    _lock = nil;
}

- (BaseDataSource*) getDataSourceOfType:(Class)type
{
    return [self getDataSourceOfType:type rssType:-1];
}

- (BaseDataSource*) getDataSourceOfType:(Class)type rssType:(rssDataType)rssType
{
    NSString* key = [type description];
    
    if (rssType != -1)
        key = [[type description] stringByAppendingFormat:@"_rss%i",rssType];
    
    if (![_dataSources objectForKey:key])
      
    if (rssType == -1)  
        [_dataSources setObject:[[type new] autorelease] forKey:key];
    else 
        [_dataSources setObject:[[[RSSDataSource alloc] initWithType:rssType] autorelease] forKey:key];
    
    return [_dataSources objectForKey:key];
}

- (void) updateDataSourceWithType:(Class)type
{
    [[self getDataSourceOfType:type] update];
}

- (void) updateAllDataSources
{
    [_lock lock];
    
    for (BaseDataSource* dataSource in [_dataSources allValues])
        [dataSource update];
    
    [_lock unlock];
}

@end
