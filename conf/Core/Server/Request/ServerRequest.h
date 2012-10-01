//
//  ServerRequest.h


#import <Foundation/Foundation.h>
#import "serverConfig.h"
#import "ASIHttpRequest.h"
#import "ServerResponse.h"
#import "ServerResponseXMLParser.h"

@class ServerResponse;

@interface ServerRequest : NSObject <ServerResponseXMLParserDelegate>
{
	ServerResponse* serverResponse;
	ServerResponseXMLParser* parser;
    
	NSString* apiMethod;
	NSMutableDictionary* parameters;
	NSArray* defaultParameters;
    
	BOOL isStarted;
	
	NSObject*	delegate;
	SEL			didFinishSelector;
	SEL			didFailSelector;
	
	NSData*	 responseData;
	NSString* responseString;
	
	NSError* error;
	
	BOOL isRunning;
	BOOL isSent;
	BOOL isCanceled;
	BOOL isGetFromCache;
	BOOL isFailedBody;
	BOOL isFail;
	
	BOOL useCache;		// YES by default.
	BOOL isSynchronous;
	BOOL useSignature;
	
	// Activity view parameters.
	
	BOOL isActivitiViewShown;
	BOOL requiredActivityView;
	NSString* activityViewText;
	
	ASIHTTPRequest* _request;
	NSString* cacheFileName;
	
	NSMutableDictionary* additionalInfo;
    NSString* apiURL;
}

@property (copy) NSString* apiURL;
@property (readonly) ServerResponse* response;

@property (readonly) BOOL isRunning;
@property (readonly) BOOL isGetFromCache;

@property (assign) NSObject* delegate;
@property (assign) SEL didFinishSelector;
@property (assign) SEL didFailSelector;

@property (readonly) NSError* error;

@property (readwrite) BOOL useCache;
@property (readwrite) BOOL useSignature;

@property (readwrite) BOOL requiredActivityView;
@property (copy) NSString* activityViewText;

@property (readonly) NSData* responseData;
@property (readonly) NSString* responseString;

@property (retain) NSString* apiMethod;
@property (retain) NSMutableDictionary* parameters;

@property (retain) NSMutableDictionary* additionalInfo;

+ (ServerRequest*) requestWithApiMethod:(NSString*)apiMethod parameters:(NSMutableDictionary*)parameters;

- (void) setParameterValue:(NSString*)value forKey:(NSString*)key;

- (void) startSynchronous;
- (void) startAsynchronous;
- (void) cancel;

@end
