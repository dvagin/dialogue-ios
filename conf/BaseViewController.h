//
//  BaseViewController.h
//  glent
//
//  Created by админ on 04.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomNavigationBar.h"

@interface BaseViewController : UIViewController
{
    CustomNavigationBar * customNavigationBar;
}

@property (nonatomic,retain) CustomNavigationBar * customNavigationBar;


@end
