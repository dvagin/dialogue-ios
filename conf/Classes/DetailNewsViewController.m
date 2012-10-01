//
//  DetailNewsViewController.m
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "DetailNewsViewController.h"

@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController
@synthesize browser;
@synthesize externalLink;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithBody:(NSString*) _body
{
    fromRSSdata = YES;
    forImage = NO;
    NSString * newBody = [_body stringByAppendingString:@"<div><p><a href=#>Read more...</a></p></div>"];
    
    body = [[NSString alloc] initWithString:newBody];
    return [self initWithNibName:@"DetailNewsViewController" bundle:[NSBundle mainBundle]];
}

- (id) initWithImage64:(NSString*) image
{
    fromRSSdata = YES;
    forImage = YES;
    
    body = [[NSString alloc] initWithString:image];
    
    return [self initWithNibName:@"DetailNewsViewController" bundle:[NSBundle mainBundle]];
}

- (id) initWithURL:(NSURL*) _url
{
    fromRSSdata = NO;
    forImage = NO;
    
    url = _url;
    return [self initWithNibName:@"DetailNewsViewController" bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (fromRSSdata)
        [browser loadHTMLString:body baseURL:nil];
    else 
        [browser loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:300]];
    
    if (forImage)
    {
        browser.scalesPageToFit = YES;
    }
    
    customNavigationBar.leftBarItemView = [CustomNavigationBar createBarButtonWithTarget:self action:@selector(goBack) normalImageName: @"backButton.png"];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([browser isLoading])
        [browser stopLoading];
}

- (void)viewDidUnload
{
    browser = nil;
    [self setBrowser:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType 
{
    if ( inType == UIWebViewNavigationTypeLinkClicked && fromRSSdata) 
    {
//        DetailNewsViewController* dvc = [[DetailNewsViewController alloc] initWithURL:[NSURL URLWithString:externalLink]];
//        [self.navigationController pushViewController:dvc animated:YES];
        
//        if ([browser isLoading])
//            [browser stopLoading];
//        
//        [browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:externalLink]]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:externalLink]];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
