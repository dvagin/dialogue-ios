//
//  CacheManager.m


#import "CacheManager.h"
#import "constants.h"
#import "FileHelper.h"

#define kCacheInfoFileKey @"cache_info"
#define kFileNameKey @"fileName"
#define kTimeIntervalKey @"timeInterval"

static CacheManager* __defaultCacheManager = nil;

@implementation CacheManager

+ (CacheManager*) defaultManager
{
	if (!__defaultCacheManager)
		__defaultCacheManager = [CacheManager new];
	
	return __defaultCacheManager;
}

- (id) init
{
	if (self = [super init])
	{
		[self load];
	}
	
	return self;
}

- (id) retain
{
	return self;
}

- (NSUInteger) retainCount
{
	return UINT_MAX;
}

- (NSString*) imagesDirectory
{
	if (!_imagesDirectory)
		_imagesDirectory = [[FileHelper imagesDirectory] retain];
	
	return _imagesDirectory;
}

- (void) load
{
	NSData* data = [DEFAULTS objectForKey:kCacheInfoFileKey];
	
	if (data)
		_content = (NSMutableDictionary*)[[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];
	
	if (!_content)
		_content = [NSMutableDictionary new];
}

- (void) store
{
	[DEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:_content] forKey:kCacheInfoFileKey];
    [DEFAULTS synchronize];
}

- (void) removeCacheInfoForFileWithName:(NSString*)fileName
{
	[FileHelper removeFileAtPath:[[FileHelper cacheDirectory] stringByAppendingPathComponent:fileName]];
	[_content removeObjectForKey:fileName];
	[self store];
}

- (NSData*) getContentOfFileWithName:(NSString*)fileName
{
	NSString* cacheDirectory = [FileHelper cacheDirectory];
	
	if (!cacheDirectory)
		return nil;
	
	NSString* timeIntervalString = [_content objectForKey:fileName];
	
	if (!timeIntervalString)
		return nil;
	
	if ([timeIntervalString doubleValue] > [[NSDate date] timeIntervalSince1970])
		return [NSData dataWithContentsOfFile:[cacheDirectory stringByAppendingPathComponent:fileName]];
	
	return nil;
}

- (NSData*) getContentOfFileWithNameIfExist:(NSString*)fileName
{
    NSString* cacheDirectory = [FileHelper cacheDirectory];
	
	if (!cacheDirectory)
		return nil;
	
	return [NSData dataWithContentsOfFile:[cacheDirectory stringByAppendingPathComponent:fileName]];
}

- (void) saveData:(NSData*)data toFileWithName:(NSString*)fileName forTimeInterval:(NSTimeInterval)timeInterval
{
	NSString* cacheDirectory = [FileHelper cacheDirectory];
	
	if (!cacheDirectory)
		return;
	
	NSString* timeIntervalString = [_content objectForKey:fileName];
	
	if (timeIntervalString)
		[self removeCacheInfoForFileWithName:fileName];
	
	if ([FileHelper storeFileToPath:[cacheDirectory stringByAppendingPathComponent:fileName] fileContent:data])
		[_content setValue:[NSString stringWithFormat:@"%f", timeInterval] forKey:fileName];
    //[self store];
}

- (BOOL) imageExistsForURL:(NSString*)url
{
	if (!url)
		return NO;
	
	return [FileHelper fileExistWithName:[FileHelper fileNameFromURL:url] atDirectory:[self imagesDirectory]];
}

- (UIImage*) getImageForURL:(NSString*)url
{
	if (!url)
		return nil;

	NSData* data = [FileHelper readFileWithName:[FileHelper fileNameFromURL:url] fromDirectory:[self imagesDirectory]];
	return (data ? [UIImage imageWithData:data] : nil);
}

- (UIImage*) getImageWithNilImageForURL:(NSString*)url videoType:(BOOL)video
{
	if (!url)
		return nil;
    
	NSData* data = [FileHelper readFileWithName:[FileHelper fileNameFromURL:url] fromDirectory:[self imagesDirectory]];
    if (data== nil) return [UIImage imageNamed:(!video) ? @"camera-small.png" : @"play_wm_small.png"];
	return (data ? [UIImage imageWithData:data] : nil);
}

- (void) storeImageData:(NSData*)data forURL:(NSString*)url
{
	NSString* path = [[FileHelper imagesDirectory] stringByAppendingPathComponent:[FileHelper fileNameFromURL:url]];
	[FileHelper storeFileToPath:path fileContent:data];
}

@end