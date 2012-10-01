//
//  FileHelper.m


#import "FileHelper.h"
#import "MyDebug.h"

static FileHelper* __defaultFileHelper = nil;

@implementation FileHelper

+ (FileHelper*) defaultHelper
{
	if (!__defaultFileHelper)
		__defaultFileHelper = [FileHelper new];
	
	return __defaultFileHelper;
}

- (id) retain
{
	return self;
}

- (oneway void) release {}

- (NSUInteger) retainCount
{
	return UINT_MAX;
}

+ (NSString*) fileNameFromURL:(NSString*)url
{
	return [NSString stringWithString:[url stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
}

+ (NSString*) documentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	if ([paths count] > 0)
		return [paths objectAtIndex:0];
	
	MethodError(@"documentsDirectory", @"Directory doesn't exist.");
	
	return nil;
}

+ (NSString*) getDirectoryWithName:(NSString*)directoryName
{
	NSString* documentsDirectory = [FileHelper documentsDirectory];
	
	if (!documentsDirectory)
		return nil;
	
	NSString* pathToCacheDirectory = [documentsDirectory stringByAppendingPathComponent:directoryName];
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	BOOL isDirectory;
	
	if (![fileManager fileExistsAtPath:pathToCacheDirectory isDirectory:&isDirectory] || !isDirectory)
	{
		NSError* error = nil;
		
		if (![fileManager createDirectoryAtPath:pathToCacheDirectory withIntermediateDirectories:YES attributes:nil error:&error])
		{
			NSString* errorMessage = [NSString stringWithFormat:@"Can't create a directory at path: %@.\nError: %@.", 
									  pathToCacheDirectory, [error description]];
			MethodError(@"getDirectoryWithName", errorMessage);
			return nil;
		}
	}
	
	return pathToCacheDirectory;
}

+ (NSString*) cacheDirectory
{
	return [self getDirectoryWithName:kCacheDirectoryName];
}

+ (NSString*) imagesDirectory
{
	return [self getDirectoryWithName:kImagesDirectoryName];
}

+ (NSString*) filesDirectory
{
	return [self getDirectoryWithName:kFilesDirectoryName];
}

+ (BOOL) storeFileToPath:(NSString*)pathToFile fileContent:(NSData*)fileContent
{
	return [[NSFileManager defaultManager] createFileAtPath:pathToFile contents:fileContent attributes:nil];
}

+ (void) removeFileAtPath:(NSString*)pathToFile
{
	NSError* error = nil;

	if (![[NSFileManager defaultManager] fileExistsAtPath:pathToFile])
	{
		NSString* errorMessage = [NSString stringWithFormat:@"File doesn't exist at path: %@", pathToFile];
		MethodError(@"removeFileAtPath:", errorMessage);
		return;
	}
	
	if (![[NSFileManager defaultManager] removeItemAtPath:pathToFile error:&error])
	{
		MethodError(@"removeFileAtPath:", [error description]);
	}
}

+ (NSData*) readFileWithName:(NSString*)fileName fromDirectory:(NSString*)directory
{
	if (!directory || !fileName)
		return nil;
	
	return [NSData dataWithContentsOfFile:[directory stringByAppendingPathComponent:fileName]];
}

+ (BOOL) fileExistAtPath:(NSString*)pathToFile
{
	return [[NSFileManager defaultManager] fileExistsAtPath:pathToFile];
}

+ (BOOL) fileExistWithName:(NSString*)fileName atDirectory:(NSString*)directory
{
	return [self fileExistAtPath:[directory stringByAppendingPathComponent:fileName]];
}

@end
