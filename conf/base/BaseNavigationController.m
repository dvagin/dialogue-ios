
//

#import "BaseNavigationController.h"


@implementation BaseNavigationController

- (id) initWithRootViewController:(UIViewController*)rootViewController tabName:(NSString*)tabName tabImage:(UIImage*)tabImage
{
	if (self = [super initWithRootViewController:rootViewController])
	{
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabName image:tabImage tag:0];
        self.navigationBar.tintColor = [UIColor greenColor];
        self.navigationBarHidden = YES;
	}
		
	return self;
}


@end
