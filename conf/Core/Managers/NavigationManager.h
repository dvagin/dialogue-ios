//
//

#import <Foundation/Foundation.h>

#define NAVIGATION_MANAGER [NavigationManager defaultManager]
#define MAIN_NAVIGATION_CONTROLLER NAVIGATION_MANAGER.mainNavigationController

@interface NavigationManager : NSObject
{
    UINavigationController* mainNavigationController;
}

@property (nonatomic, retain) UINavigationController* mainNavigationController;

+ (NavigationManager*) defaultManager;

- (void) clearViewControllers;

@end
