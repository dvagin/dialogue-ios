//
//  FileHelper.h


#import <Foundation/Foundation.h>

#define FILE_HELPER [FileHelper]

#define kCacheDirectoryName @"cache"
#define kImagesDirectoryName @"images"
#define kFilesDirectoryName @"files"

@interface FileHelper : NSObject
{
	
}

+ (FileHelper*) defaultHelper;

+ (NSString*) fileNameFromURL:(NSString*)url;

+ (NSString*) documentsDirectory;
+ (NSString*) filesDirectory;
+ (NSString*) imagesDirectory;
+ (NSString*) cacheDirectory;

+ (NSData*) readFileWithName:(NSString*)fileName fromDirectory:(NSString*)directory;

+ (BOOL) storeFileToPath:(NSString*)pathToFile fileContent:(NSData*)fileContent;
+ (void) removeFileAtPath:(NSString*)pathToFile;

+ (BOOL) fileExistAtPath:(NSString*)pathToFile;
+ (BOOL) fileExistWithName:(NSString*)fileName atDirectory:(NSString*)directory;

@end
