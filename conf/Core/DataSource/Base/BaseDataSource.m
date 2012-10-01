//
//  BaseDataSource.m


#import "BaseDataSource.h"
#import "DateHelper.h"
#import "Notifications.h"

#define kTimeIntervalForStart 5
#define kLastUpdateDateKey @"lastUpdateDate"

@implementation BaseDataSource

+ (NSArray*) arrayVersionOfResult:(NSObject*)object
{
    if (!object)
        return [NSArray array];
    
    if (![object isKindOfClass:[NSArray class]])
          return [NSArray arrayWithObject:object];
          
    return (NSArray*)object;
}

+ (id) new
{
    return [[[self class] alloc] init];
}

@synthesize repeatRequests;
@synthesize clearCacheAfterUpdate;
@dynamic isRunning;
@synthesize lastUpdateDate;
@synthesize hasReallyNewItems = _hasReallyNewItems;
@dynamic size;
@synthesize hasData = _hasData;
@synthesize customLoadingCompleteNotification, customLoadingFailedNotification;

- (void) invalidateTimer
{
    if (_timer)
	{
		if ([_timer isValid])
			[_timer invalidate];
		
		[_timer release];
		_timer = nil;
	}
}

- (id)init
{
    if (self = [super init])
    {
        _isTimerMode = NO;
        _isStarted = NO;
        _lastUpdateTime = [[NSDate date] timeIntervalSince1970];
        self.repeatRequests = NO;
        self.clearCacheAfterUpdate = YES;
        _hasData = NO;
        _hasReallyNewItems = YES;
        isFirstUpdate = YES;
        
        [self loadState];
    }
    
    return self;
}

- (id) initWithTimeout:(NSTimeInterval)timeout
{
	if (self = [super init])
	{
		_timeout = timeout;
		_lastUpdateTime = [[NSDate date] timeIntervalSince1970];
        _isStarted = NO;
        _isTimerMode = YES;
        self.clearCacheAfterUpdate = YES;
        self.repeatRequests = NO;
        _hasReallyNewItems = YES;
        isFirstUpdate = YES;
        
        [self loadState];
	}
    
	return self;
}

- (void) dealloc
{
    [_request cancel];
    [_request release];
    [_data release];
    [self invalidateTimer];
    self.customLoadingFailedNotification = nil;
    self.customLoadingCompleteNotification = nil;
    [super dealloc];
}

+ (NSString*) defaultName
{
    return [[self class] description];
}

- (NSInteger) size
{
    return 0;
}

#pragma mark -
#pragma mark State

- (void) loadState
{
    NSString* lastUpdateDateString = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateDateKey];
    lastUpdateDate = [[DateHelper deserializeDate:lastUpdateDateString] retain];    
    
    if (!lastUpdateDate)
        lastUpdateDate = [[NSDate date] retain];
}

- (void) storeState
{
    [[NSUserDefaults standardUserDefaults] setValue:[DateHelper serializeDate:lastUpdateDate] forKey:kLastUpdateDateKey];
}

#pragma mark -
#pragma mark Items

- (NSString*) itemIdKey
{
    return @"id";
}

- (NSDictionary*) getItemById:(NSString*)itemId fromDataSource:(NSArray*)dataSource
{
    NSString* itemIdKey = [self itemIdKey];
    
    if (itemIdKey && dataSource)
    {
        for (NSDictionary* item in dataSource)
            if ([[item objectForKey:itemIdKey] isEqualToString:itemId])
            {
                return item;
            }
    }
    
    return nil;
}

#pragma mark -
#pragma mark Data

- (NSMutableDictionary*) data
{
    if (!_data)
        _data = [NSMutableDictionary new];
    
    return _data;
}

- (void) setObject:(NSObject*)object forKey:(NSString*)key
{
    if (object && key && key.length > 0)
    {
        [[self data] setObject:object forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:[key stringByAppendingString: [[self class] description]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (key)
        [[self data] removeObjectForKey:key];
}

- (NSObject*) getObjectForKey:(NSString*)key
{
    id defaultsObject = [[NSUserDefaults standardUserDefaults] objectForKey:[key stringByAppendingString: [[self class] description]]];
    if (defaultsObject)
    {
        if (defaultsObject && key && key.length > 0)
            [[self data] setObject:defaultsObject forKey:key];
    }
    return [[self data] objectForKey:key];
}

- (NSArray*) getArrayForKey:(NSString*)key
{
    NSArray* items = (NSArray*)[self getObjectForKey:key];
    
    if (!items)
    {
        items = [NSArray array];
        [self setObject:items forKey:key];
    }
    
    return items;
}

#pragma mark -
#pragma mark Cache

- (void) clearCache
{
    [_cache release];
    _cache = nil;
}

- (NSMutableDictionary*) cache
{
    if (!_cache)
        _cache = [NSMutableDictionary new];
    
    return _cache;
}

- (void) setDataToCache:(NSObject*)data forKey:(NSString*)dataKey
{
    if (data && dataKey && dataKey.length > 0)
        [[self cache] setObject:data forKey:dataKey];
}

- (NSObject*) getDataFromCacheForKey:(NSString*)dataKey
{
    return [[self cache] objectForKey:dataKey];
}

- (void) fillRequestBody:(ServerRequest*)request
{
    @throw [NSException exceptionWithName:@"NotImplementedException" 
                                   reason:[NSString stringWithFormat:@"Method 'fillRequestBody:' should be overriden in class '%@'.", [[self class] description]] userInfo:nil];
}

- (void) update
{
    [_request cancel];
    [_request release];
    
    _request = [ServerRequest new];
    _request.delegate = self;
    _request.didFinishSelector = @selector(didRequestFinish:);
    _request.didFailSelector = @selector(didRequestFail:);
    [self fillRequestBody:_request];
    [_request startAsynchronous];
}

- (void) cancelUpdating
{
    [_request cancel];
    [_request release];
    _request = nil;
}

- (BOOL) processResponseBody:(NSDictionary*)body
{
    return YES;
}

#pragma mark -
#pragma mark Timer

- (void) start
{
	@synchronized (self)
	{
		if (_isStarted)
			return;
		
        _isTimerMode = YES;
        
		if (_timer)
		{
			if ([_timer isValid])
				[_timer invalidate];
			
			[_timer release];
			_timer = nil;
		}
		
		if (_timeout > 0)
		{
			NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSince1970] - _lastUpdateTime;
			NSTimeInterval timeout = MAX(_timeout - elapsedTime, 0);
            
			_timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimeIntervalForStart] 
                                              interval:timeout 
                                                target:self selector:@selector(update) userInfo:nil repeats:NO];
			[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
			
			_isStarted = YES;
		}
		else
		{
			NSLog(@"Fail to start service %@ with a zero time interval.", [[self class] description]);
		}
	}
}

- (void) stop
{
	@synchronized (self)
	{
		[self invalidateTimer];
        [self cancelUpdating];
		
		_isStarted = NO;
        _isTimerMode = NO;
	}
}

- (void) restart
{
	[self stop];
	[self start];
}

- (BOOL) isRunning
{
    if (_isTimerMode)
        return _isStarted;
    
    return _request.isRunning;
}

- (void) setupTimer
{
	if (_timer)
	{
		if ([_timer isValid])
			[_timer invalidate];
		
		[_timer release];
		_timer = nil;
	}
	
	if (_timeout > 0)
	{
		NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSince1970] - _lastUpdateTime;
		NSTimeInterval timeout = MAX(_timeout - elapsedTime, 0);

		_timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:timeout] interval:timeout
											target:self selector:@selector(update) userInfo:nil repeats:NO];
		
		[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
	}
}

- (void) loadingCompleted
{
    _hasData = YES;
    
    [lastUpdateDate release];
    lastUpdateDate = [[NSDate date] retain];
    _lastUpdateTime = [[NSDate date] timeIntervalSince1970];
    
    if (self.customLoadingCompleteNotification && self.customLoadingCompleteNotification.length > 0)
        postNotificationWithNameAndObject(self.customLoadingCompleteNotification, self);    
    else
        postNotificationWithNameAndObject(kNotificationDataSourceUpdateIsCompleted, self);

    if (_isTimerMode && self.repeatRequests)
        [self performSelectorOnMainThread:@selector(setupTimer) withObject:nil waitUntilDone:[NSThread isMainThread]];
}

- (void) loadingFailed
{
    _lastUpdateTime = [[NSDate date] timeIntervalSince1970];
    
    if (self.customLoadingFailedNotification && self.customLoadingFailedNotification.length > 0)
        postNotificationWithNameAndObject(self.customLoadingFailedNotification, self);    
    else
        postNotificationWithNameAndObject(kNotificationDataSourceUpdateIsFailed, self);

    if (_isTimerMode && self.repeatRequests)
        [self performSelectorOnMainThread:@selector(setupTimer) withObject:nil waitUntilDone:[NSThread isMainThread]];
}

#pragma mark -
#pragma mark ServerRequest delegate methods

- (void) didRequestFinish:(ServerRequest*)request
{
    _isStarted = NO;
    
    if (request.response.isErrorResponse)
    {
        NSLog(@"Error response: code is %d, descriptions is %@", request.response.errorCode, request.response.errorDescription);
        [self loadingFailed];
        return;
    }
    
    if ([self processResponseBody:request.response])
    {
        _hasReallyNewItems = !request.isGetFromCache || isFirstUpdate;
        
        if (self.clearCacheAfterUpdate && _hasReallyNewItems)
            [self clearCache];
        
        [self loadingCompleted];
    }
    else
        [self loadingFailed];
    
    isFirstUpdate = NO;
}

- (void) didRequestFail:(ServerRequest*)request
{
    _isStarted = NO;
    [self loadingFailed];
}

-(BOOL)isRetina
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? 1 : 0;
}

@end
