//
//  NSStringMD5.h


#import <Foundation/Foundation.h>


@interface NSString (NSStringAdditions)

- (NSString*) md5;

- (NSString*) trim;

+ (NSString*) emptyStringIfNil:(NSString*)value;

@end
