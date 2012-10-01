//
//  CacheManager.h


#import <Foundation/Foundation.h>

#define CACHE_MANAGER [CacheManager defaultManager]
#define GET_FILE_DATA_FROM_CACHE(fileName) [CACHE_MANAGER getContentOfFileWithName:fileName]
#define GET_FILE_DATA_FROM_CACHE_IF_EXIST(fileName) [CACHE_MANAGER getContentOfFileWithNameIfExist:fileName]
#define STORE_FILE_TO_CACHE(data, fileName, timeInterval) [CACHE_MANAGER saveData:data toFileWithName:fileName forTimeInterval:timeInterval]

@interface CacheManager : NSObject
{
	NSMutableDictionary* _content;	// Each item contains the following fields: fileKey -> timeInterval (from the 1st January 1970)
	NSString* _imagesDirectory;
}

+ (CacheManager*) defaultManager;

- (void) load;
- (void) store;

- (NSData*) getContentOfFileWithName:(NSString*)fileName;
- (NSData*) getContentOfFileWithNameIfExist:(NSString*)fileName;
- (void) saveData:(NSData*)data toFileWithName:(NSString*)fileName forTimeInterval:(NSTimeInterval)timeInterval;

- (BOOL) imageExistsForURL:(NSString*)url;
- (UIImage*) getImageForURL:(NSString*)url;
- (UIImage*) getImageWithNilImageForURL:(NSString*)url videoType:(BOOL)video;
- (void) storeImageData:(NSData*)data forURL:(NSString*)url;

@end
