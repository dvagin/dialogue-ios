//
//  DetailNewsViewController.h
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DetailNewsViewController : BaseViewController
{
    NSString * body;
    NSURL * url;
    IBOutlet UIWebView *browser;
    BOOL fromRSSdata;
    BOOL forImage;
    
    
}
@property (strong, nonatomic) IBOutlet UIWebView *browser;

@property (nonatomic,strong) NSString * externalLink;
- (id) initWithBody:(NSString*) body;
- (id) initWithImage64:(NSString*) image;
- (id) initWithURL:(NSURL*) _url;

@end
