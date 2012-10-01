

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController
{

}

- (id) initWithRootViewController:(UIViewController*)rootViewController tabName:(NSString*)tabName tabImage:(UIImage*)tabImage;

@end
