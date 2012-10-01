//
//  ServerResponse.m


#import "ServerResponse.h"
#import "MyDebug.h"
#import "serverConfig.h"

#define IsElementHasName(element, name) [[element objectForKey:kElementName] isEqualToString:name]

@interface ServerResponse ()

- (id) initWithError:(NSString*)responseError;

@end

@implementation ServerResponse

@synthesize errorCode = _errorCode;
@synthesize errorDescription = _errorDescription;
@synthesize cacheTime = _cacheTime;
@synthesize body = _body;
@dynamic isErrorResponse;

- (id) initWithErrorCode:(NSInteger)errorCode
        errorDescription:(NSString*)errorDescription
               cacheTime:(NSTimeInterval)cacheTime
                    body:(NSDictionary*)body
{
    if (self = [super init])
    {
        _errorCode = errorCode;
        _errorDescription = [errorDescription retain];
        _cacheTime = cacheTime;
        _body = [body retain];
    }
    
    return self;    
}

+ (NSObject*) getXmlNodeValue:(NSDictionary*)xmlNode isHead:(BOOL)isHead
{
    return [self getXmlNodeValue:xmlNode isHead:isHead showAttributes:NO];
}

+ (NSObject*) getXmlNodeValue:(NSDictionary*)xmlNode isHead:(BOOL)isHead showAttributes:(BOOL)showAttributes
{
    NSObject* value = nil;
    NSArray* xmlNodeChildren = [xmlNode objectForKey:kElementChildren];
    
    NSString * nodeTitle = [xmlNode objectForKey:kElementName];
    
    NSDictionary* nodeAttr = [xmlNode objectForKey:kElementAttibutes];
    
    
    if (xmlNodeChildren && xmlNodeChildren.count > 0)
    {
        NSMutableDictionary* nodeChildren = [NSMutableDictionary dictionaryWithCapacity:1];
        
        for (NSDictionary* child in xmlNodeChildren)
        {
            NSString* childName = [child objectForKey:kElementName];
            NSObject* childValue = [self getXmlNodeValue:child isHead:NO];
            NSObject* childItem = [nodeChildren objectForKey:childName];
            NSDictionary* childAttr = [child objectForKey:kElementAttibutes];
            
            if (childItem != nil)
            {
                if ([childItem isKindOfClass:[NSMutableArray class]])
                {
                    if (!showAttributes) 
                        [(NSMutableArray*)childItem addObject:childValue];
                    else 
                    {
                        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:childValue, childName, nil];
                        if (childAttr.count)
                        {
                            for (NSString * key in childAttr) 
                            {
                                NSString * attrValue = [childAttr objectForKey:key];
                                
                                [dic setObject:attrValue forKey:key]; 
                            }
                        }
                        [(NSMutableArray*)childItem addObject:dic];
                        
                    }
                }
                else
                {
                    if (!showAttributes)
                        [nodeChildren setValue:[NSMutableArray arrayWithObjects:childItem, childValue, nil] forKey:childName];
                    else 
                    {
                        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:childValue,childName, nil];
                        if (childAttr.count)
                        {
                            for (NSString * key in childAttr) 
                            {
                                NSString * attrValue = [childAttr objectForKey:key];
                                
                                [dic setObject:attrValue forKey:key]; 
                            }
                        }
                        
                        [nodeChildren setValue:[NSMutableArray arrayWithObjects:childItem, dic, nil] forKey:childName];
                    }
                }
            }
            else // childItem == nil
            {
                if (!showAttributes)
                    [nodeChildren setValue:childValue forKey:childName];
                else 
                {
                    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:childValue,childName, nil];
                    if (childAttr.count)
                    {
                        for (NSString * key in childAttr) 
                        {
                            NSString * attrValue = [childAttr objectForKey:key];
                            
                            [dic setObject:attrValue forKey:key]; 
                        }
                    }
                    
                    [nodeChildren setValue:dic forKey:childName];
                }
            }    
        }
        value = nodeChildren;
    }
    else
        value = [xmlNode objectForKey:kElementValue];
    
    if (!isHead)
        return value;
    
    NSMutableDictionary* elementValue = [NSMutableDictionary dictionary];
    
    if (value)
        [elementValue setObject:value forKey:[xmlNode objectForKey:kElementName]];
    
    for (NSString * key in nodeAttr) 
    {
        NSString * attrValue = [nodeAttr objectForKey:key];
        
        [elementValue setObject:attrValue forKey:key]; 
    }

    
    return elementValue;
    
}

+ (ServerResponse*) createFromXMLTree:(NSDictionary*)xmlTree
{
    if (!xmlTree || [xmlTree allKeys].count != 1)
	{
		MethodError(@"createFromXMLTree", @"XML tree is nil, empty or has more that 1 root element.");
		return nil;
	}
	
    NSDictionary* root = [[xmlTree allValues] objectAtIndex:0];
	
    NSArray* rootChildren = [root objectForKey:kElementChildren];
    
	if (!rootChildren)
    {
        MethodError(@"createFromXMLTree", @"The response doesn't contains child elements.");
        return [[[ServerResponse alloc] initWithError:NSLocalizedString(@"ResponseError", @"")] autorelease];
    }

    
    BOOL hasErrorCode = NO,
         hasErrorDescription = NO,
         hasCacheTime = NO,
         hasBody = NO;
    
    NSInteger errorCode = 0;
    NSString* errorDescription = nil;
    NSTimeInterval cacheTime = 0;
    NSMutableDictionary * body = [NSMutableDictionary dictionary];
	
    
    for (NSDictionary* element in rootChildren)
    {
        NSString* elementName = [element objectForKey:kElementName];
        NSDictionary* attributes = [element objectForKey:kElementAttibutes];
        NSString * attributeName = [attributes objectForKey:@"name"];
        
        NSMutableArray * array = [NSMutableArray array];
        
        if ([elementName isEqualToString:@"Hall"])
        {
            NSArray* children = [[element objectForKey:kElementChildren] retain];
            
            if (children != nil && children.count > 0)
            {
                for (NSDictionary* oneDict in children) 
                {
                    NSDictionary * oneBody = (NSDictionary*)[self getXmlNodeValue:oneDict isHead:YES showAttributes:YES];
                    [array addObject:oneBody];
                }
               
                hasBody = YES;
            }
            
            [children release];
            
        }
        
        if ([elementName isEqualToString:@"channel"])
        {
            NSArray* children = [[element objectForKey:kElementChildren] retain];
            
            for (NSDictionary* oneDict in children) 
            {
                NSDictionary * oneBody = (NSDictionary*)[self getXmlNodeValue:oneDict isHead:YES showAttributes:YES];
                [array addObject:oneBody];
            }
            
            hasBody = YES;
        }
        if (attributeName == nil)
            attributeName = elementName;
        
        if (array != nil)
            [body setObject:array forKey:attributeName];
    }
    
    BOOL isValidResponseStructure = /*hasErrorCode && hasErrorDescription && hasCacheTime &&*/ hasBody;
    
    if (!isValidResponseStructure)
    {
        MethodError(@"createFromXMLTree", @"Invalid response structure.");
        return [[[ServerResponse alloc] initWithError:NSLocalizedString(@"ResponseError", @"")] autorelease];
    }
    cacheTime = 360;
    return [[[ServerResponse alloc] initWithErrorCode:errorCode 
                                     errorDescription:errorDescription 
                                            cacheTime:cacheTime 
                                                 body:body] 
            autorelease];
}

- (void) dealloc
{
	[_errorDescription release];
    [_body release];
    [_childrenCache release];
    [_valuesCache release];
	[super dealloc];
}

- (id) initWithError:(NSString*)responseError
{
	if (!responseError)
	{
		MethodError(@"initWithError", @"An input argument can't be nil.");
		return nil;
	}
	
	return [self initWithErrorCode:-1 errorDescription:responseError cacheTime:0 body:nil];
}

- (BOOL) isErrorResponse
{
	return self.errorCode != kNoErrors;
}

#pragma -
#pragma Internal cache

- (NSMutableDictionary*) childrenCache
{
    if (!_childrenCache)
        _childrenCache = [NSMutableDictionary new];
    
    return _childrenCache;
}

- (NSMutableDictionary*) valuesCache
{
    if (!_valuesCache)
        _valuesCache = [NSMutableDictionary new];
    
    return _valuesCache;
}

#pragma -
#pragma Public methods

- (NSDictionary*) getFirstElementWithName:(NSString*)elementName parent:(NSDictionary*)root
{
    if (IsElementHasName(root, elementName))
        return root;
    
    NSDictionary* element = nil;
    
    NSArray* children = [root objectForKey:kElementChildren];
    
    if (children && children.count > 0)
        for (NSDictionary* child in children)
        {
            element = [self getFirstElementWithName:elementName parent:child];
            
            if (element)
                break;
        }
    
    return element;
}

- (NSObject*) getValueOfFirstElementWithName:(NSString*)elementName
{
    NSObject* value = [[self valuesCache] objectForKey:elementName];
    
    if (!value)
    {
        NSDictionary* element = [self getFirstElementWithName:elementName parent:_body];
      
        if (element)
        {
            value = [element objectForKey:kElementValue];
            [[self valuesCache] setValue:value forKey:elementName];
        }
    }
    
    return value;
}

- (NSArray*) getChildrenOfFirstElementWithName:(NSString*)elementName
{
    NSArray* children = [[self childrenCache] objectForKey:elementName];
    
    if (!children)
    {
        NSDictionary* element = [self getFirstElementWithName:elementName parent:_body];
        
        if (element)
        {
            // TODO: ...
        }
        
        [[self childrenCache] setValue:children forKey:elementName];
    }
    
    return children;
}

@end