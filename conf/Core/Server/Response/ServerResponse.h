//
//  ServerResponse.h


#import <Foundation/Foundation.h>

@interface ServerResponse : NSObject
{
    NSInteger _errorCode;
    NSString* _errorDescription;
    NSTimeInterval _cacheTime;
    NSDictionary* _body;
    
    NSMutableDictionary* _childrenCache;
    NSMutableDictionary* _valuesCache;
}

@property (nonatomic, readonly) NSDictionary* body;
@property (nonatomic, readonly) NSInteger errorCode;
@property (nonatomic, readonly) NSString* errorDescription;
@property (nonatomic, readonly) NSTimeInterval cacheTime;
@property (nonatomic, readonly) BOOL isErrorResponse;

+ (ServerResponse*) createFromXMLTree:(NSDictionary*)xmlTree;

- (id) initWithErrorCode:(NSInteger)errorCode
        errorDescription:(NSString*)errorDescription
               cacheTime:(NSTimeInterval)cacheTime
                    body:(NSDictionary*)body;

- (NSObject*) getValueOfFirstElementWithName:(NSString*)elementName;
- (NSArray*) getChildrenOfFirstElementWithName:(NSString*)elementName;

@end
