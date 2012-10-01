//
//  APIDownload.h
//  ipadtab
//
//  Created by админ on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface APIDownload : NSObject {    
    SEL successSelector;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSURLConnection *connection;

+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate sel:(SEL)selector;
+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate;

- (void)setSuccessSelector:(SEL)selector;
- (void)cancel;

@end