//
//  NavigationManager.m
//

#import "NavigationManager.h"

static NavigationManager* __defaultNavigationManager = nil;

@implementation NavigationManager

@synthesize mainNavigationController;

+ (NavigationManager*) defaultManager
{
    if (!__defaultNavigationManager)
        __defaultNavigationManager = [NavigationManager new];
    
    return __defaultNavigationManager;
}

- (void) clearViewControllers
{
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.mainNavigationController.viewControllers];
    [allViewControllers removeAllObjects];
    self.mainNavigationController.viewControllers = allViewControllers;
}

- (id) retain { return self; }
- (NSUInteger) retainCount { return NSUIntegerMax; }
- (oneway void) release {}

- (void) dispose
{
    
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

@end
