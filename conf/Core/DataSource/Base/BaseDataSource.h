//
//  BaseDataSource.h

//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"
#import "constants.h"

#define kNotificationDataSourceUpdateIsCompleted @"dataSourceUpdateIsCompleted"
#define kNotificationDataSourceUpdateIsFailed @"dataSourceUpdateIsFailed"

#define kNotificationArgumentDataSource @"dataSource"


#define kBooleanValueFalse @"0"
#define kBooleanValueTrue @"1"

#define IS_FALSE(value) [value isEqualToString:kBooleanValueFalse]
#define IS_TRUE(value)  !IS_FALSE(value)

// Request parameters.

#define kRequestParameterId @"id"

@interface BaseDataSource : NSObject
{
    ServerRequest* _request;
    
    NSMutableDictionary* _data;
    NSMutableDictionary* _cache;
    
    NSTimer*        _timer;
    NSTimeInterval  _lastUpdateTime;
    NSTimeInterval	_timeout;
    NSDate* lastUpdateDate;
    
    
	BOOL _isStarted;
    BOOL _isTimerMode;
    BOOL repeatRequests;
    BOOL clearCacheAfterUpdate;
    
    BOOL isFirstUpdate;
    BOOL _hasData;
    BOOL _hasReallyNewItems;
}

@property (nonatomic, readwrite) BOOL repeatRequests;
@property (nonatomic, readwrite) BOOL clearCacheAfterUpdate;
@property (nonatomic, readonly)  BOOL isRunning;
@property (nonatomic, readonly)  NSDate* lastUpdateDate;
@property (nonatomic, readonly)  BOOL hasData;
@property (nonatomic, readonly)  BOOL hasReallyNewItems;
@property (nonatomic, readonly)  NSInteger size;    // 0 by default.

@property (nonatomic, copy) NSString* customLoadingCompleteNotification;
@property (nonatomic, copy) NSString* customLoadingFailedNotification;

+ (NSArray*) arrayVersionOfResult:(NSObject*)object;

+ (id) new;

- (id) initWithTimeout:(NSTimeInterval)timeout;

- (NSString*) itemIdKey;
- (NSDictionary*) getItemById:(NSString*)itemId fromDataSource:(NSArray*)dataSource;

- (void) start;
- (void) stop;
- (void) restart;

- (void) loadState;
- (void) storeState;

- (void) clearCache;

- (NSObject*) getObjectForKey:(NSString*)key;
- (void) setObject:(NSObject*)object forKey:(NSString*)key;

- (NSArray*) getArrayForKey:(NSString*)key;

- (NSObject*) getDataFromCacheForKey:(NSString*)dataKey;
- (void) setDataToCache:(NSObject*)data forKey:(NSString*)dataKey;

- (void) fillRequestBody:(ServerRequest*)request;

- (void) update;
- (void) cancelUpdating;

- (BOOL) processResponseBody:(NSDictionary*)body;

-(BOOL) isRetina;

@end
