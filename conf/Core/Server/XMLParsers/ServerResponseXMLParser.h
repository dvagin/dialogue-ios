//
//  ServerResponseXMLParser.h


#import <Foundation/Foundation.h>
#import "AQXMLParser.h"

@class ServerResponseXMLParser;

@protocol ServerResponseXMLParserDelegate <NSObject>

- (void) didParsingComplete:(ServerResponseXMLParser*)parser;
- (void) didParsingFail:(ServerResponseXMLParser*)parser error:(NSError*)parserError;

@end

@interface ServerResponseXMLParser : NSObject <AQXMLParserDelegate>
{
	AQXMLParser*  parser;
	
	NSMutableDictionary* xmlTree;
	NSMutableDictionary* currentElement;
	NSMutableArray* stack;
	
	NSMutableString* currentElementValue;
	
	id <ServerResponseXMLParserDelegate> delegate;
}

@property (retain) id <ServerResponseXMLParserDelegate> delegate;
@property (readonly) NSMutableDictionary* xmlTree;

- (id) initWithData:(NSData*)data;

- (void) parse;
- (void) abort;

@end
