//
//  ServerRequest.m


#import "ServerRequest.h"
#import "NSStringAdditions.h"
#import "MyDebug.h"
#import "CacheManager.h"
//#import "ServerActivityView.h"

#define  kServerApiURL @"http://rhodesforum.org"
@interface ServerRequest ()

- (void) didRequestFinish:(ASIHTTPRequest*)request;
- (void) didRequestFail:(ASIHTTPRequest*)request;

- (void) didReceiveResponse:(NSData*)response;

- (void) showActivitiViewIfRequired;
- (void) hideActivityView;

@end

@implementation ServerRequest

@synthesize apiURL;
@synthesize response = serverResponse;
@synthesize isRunning;
@synthesize isGetFromCache;

@synthesize delegate;
@synthesize didFinishSelector;
@synthesize didFailSelector;

@synthesize error;

@synthesize useCache;
@synthesize useSignature;

@synthesize requiredActivityView;
@synthesize activityViewText;

@synthesize responseData;
@dynamic responseString;

@synthesize apiMethod;
@synthesize parameters;
@synthesize additionalInfo;

- (id) init
{
	if (self = [super init])
	{
		isRunning = NO;
		isSent = NO;
		isCanceled = NO;
		isGetFromCache = NO;
		isSynchronous = YES;
		self.useCache = YES;
		self.useSignature = NO;
		isFailedBody = NO;
		isFail = NO;
		requiredActivityView = NO;
		self.activityViewText = NSLocalizedString(@"Loading", @"");
		
		parameters = [NSMutableDictionary new];
	}
	
	return self;
}

- (void) dealloc
{
	[defaultParameters release];
	[parameters release];
	[apiMethod release];
	[_request release];
	[serverResponse release];
	[activityViewText release];
	[parser release];
	[cacheFileName release];
	[responseData release];
	[responseString release];
	[additionalInfo release];
    [apiURL release];
	
	[super dealloc];
}

+ (ServerRequest*) requestWithApiMethod:(NSString*)apiMethod parameters:(NSMutableDictionary*)parameters
{
    ServerRequest* request = [ServerRequest new];
    
    request.apiMethod = apiMethod;
    request.parameters = parameters;
    
    return [request autorelease];
}

- (void) setResponseData:(NSData*)data
{
	[responseString release];
	[responseData release];
	responseData = [data retain];	
}

- (NSString*) responseString
{
	if (!responseString && responseData)
		responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	return responseString;
}

- (void) setParameterValue:(NSString*)value forKey:(NSString*)key
{
	[parameters setValue:value forKey:key];
}

#pragma mark -
#pragma mark Private methods

- (BOOL) validateRequestParameters
{
    if (!apiMethod || [apiMethod trim].length == 0)
	{
		NSString* errorMessage = [NSString stringWithFormat:@"API Method isn't set but has %d parameters.", parameters.count];
		MethodError(@"validateRequestParameters", errorMessage);
		return NO;
	}
	
	return YES;
}

- (NSString*) buildRequestURL
{
    NSMutableString* url = [NSMutableString stringWithString:(apiURL ? apiURL : kServerApiURL)];
        
    //[url appendFormat:@"/%@?device_id=%@", apiMethod, [[UIDevice currentDevice] uniqueIdentifier]];
    [url appendFormat:@"/%@", apiMethod];
    
    for (NSString* key in [parameters allKeys])
        [url appendFormat:@"&%@=%@", key, [[parameters objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   NSLog(@"%@",url); //view all requests
    return url;
}

- (NSData*) getResponseFromCache:(NSString*)requestURL validateExpirationDate:(BOOL)validateExpirationDate
{
	if (!cacheFileName)
		cacheFileName = [[NSString alloc] initWithFormat:@"%@.cache", [requestURL md5]];

    if (validateExpirationDate)
        return GET_FILE_DATA_FROM_CACHE(cacheFileName);
    
    return GET_FILE_DATA_FROM_CACHE_IF_EXIST(cacheFileName);
}

- (BOOL) isCanStartNewRequest
{
	if (![self validateRequestParameters])
		return NO;
	
	if (isCanceled)
	{
		MethodError(@"isCanStartRequest", @"Request has been canceled.");
		return NO;
	}
	
	if (isSent)
	{
		MethodError(@"isCanStartRequest", @"Request has been already sent.");
		return NO;
	}
	
	return YES;
}

- (void) start:(BOOL)synchronous
{
	if (![self isCanStartNewRequest])
		return;

	isRunning = YES;	
	isSynchronous = synchronous;
	
	// Check the cache.
	
	NSString* requestURL = [self buildRequestURL];
	
//    NSLog(@"REQUEST URL: %@", requestURL);
    
	if (self.useCache)
	{
		NSData* response = [self getResponseFromCache:requestURL validateExpirationDate:YES];
		
		if (response)
		{
			isGetFromCache = YES;
			[self didReceiveResponse:response];
			return;
		}
	}
    
    // Start a new request.
	
	_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
	
	[self showActivitiViewIfRequired];
	
	isSent = YES;
	
	if (isSynchronous)
	{
		[_request startSynchronous];
		
		if (!_request.error)
			[self didRequestFinish:_request];
		else
			[self didRequestFail:_request];
	}
	else	// Start request asynchronously.
	{
		_request.delegate = self;
		_request.didFinishSelector = @selector(didRequestFinish:);
		_request.didFailSelector = @selector(didRequestFail:);
		
		[_request startAsynchronous];
	}
}

- (void) startSynchronous
{
	[self start:YES];
}

- (void) startAsynchronous
{
	[self start:NO];
}

- (void) cancel
{
	@synchronized (self)
	{
		if (isCanceled)
			return;
		
		isCanceled = YES;
		
		self.delegate = nil;
		
		_request.delegate = nil;
		[_request cancel];
		[_request release];
		_request = nil;
		
		[parser abort];
		[parser release];
		parser = nil;
        
        [serverResponse release];
        serverResponse = nil;
	}
	
	[self hideActivityView];
}

- (void) onRequestFinished
{
	_request.delegate = nil;
	_request.didFailSelector = nil;
	_request.didFinishSelector = nil;
	
	parser.delegate = nil;
	
	[self hideActivityView];
	
	if (isSynchronous)
		return;
	
    if (delegate && didFinishSelector && [delegate respondsToSelector:didFinishSelector])
		[delegate performSelectorOnMainThread:didFinishSelector withObject:self waitUntilDone:YES];
	
	isRunning = NO;
}

- (void) onRequestFailed
{
    if (isCanceled)
        MethodError(@"onRequestFailed - CANCELED", [[_request url] absoluteString]);
    else    
    {
        MethodError(@"onRequestFailed", [[_request url] absoluteString]);
        isFail = YES;
    }
	
	[self hideActivityView];
	
	if (isSynchronous)
		return;
	
	if (delegate && didFailSelector && [delegate respondsToSelector:didFailSelector])
		[delegate performSelectorOnMainThread:didFailSelector withObject:self waitUntilDone:YES];
	
	isRunning = NO;
}

- (void) didReceiveResponse:(NSData*)response
{
	[responseData release];
	responseData = [response retain];
	
	parser = [[ServerResponseXMLParser alloc] initWithData:responseData];
	
	parser.delegate = self;
	
	if (isSynchronous)
		[parser parse];
	else
		[parser performSelectorInBackground:@selector(parse) withObject:nil];
}

#pragma mark -
#pragma mark ASIFormDataRequest

- (void) didRequestFinish:(ASIHTTPRequest*)request
{
	[self didReceiveResponse:[request responseData]];
}

- (void) didRequestFail:(ASIHTTPRequest*)request
{
    NSString* requestURL = [self buildRequestURL];
	
	if (self.useCache)
	{
		NSData* response = [self getResponseFromCache:requestURL validateExpirationDate:NO];
		
		if (response)
		{
			isGetFromCache = YES;
			[self didReceiveResponse:response];
			return;
		}
	}
    
	[self onRequestFailed];
}

#pragma mark -
#pragma mark ServerResponseXMLParserDelegate

- (void) didParsingComplete:(ServerResponseXMLParser*)aParser
{
	serverResponse = [[ServerResponse createFromXMLTree:aParser.xmlTree] retain];
    
	if (!isGetFromCache && self.useCache)
		STORE_FILE_TO_CACHE(responseData, cacheFileName, [[NSDate date] timeIntervalSince1970] + serverResponse.cacheTime);
	
	[self onRequestFinished];
}

- (void) didParsingFail:(ServerResponseXMLParser*)aParser error:(NSError*)parserError
{
	[error release];
	error = [parserError retain];
	
	[self onRequestFailed];
}

#pragma mark -
#pragma mark Server Activity View

- (void) showActivitiViewIfRequired
{
	if (self.requiredActivityView && self.activityViewText && self.activityViewText.length > 0)
	{
		//[[ServerActivityView sharedView] showWithText:self.activityViewText];
		isActivitiViewShown = YES;
	}
}

- (void) hideActivityView
{
	if (isActivitiViewShown)
		//[[ServerActivityView sharedView] hide];
	
	isActivitiViewShown = NO;
}

@end