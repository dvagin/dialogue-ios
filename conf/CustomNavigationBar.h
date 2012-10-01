//
//  CustomNavigationBar.h



#import <UIKit/UIKit.h>

#define kDefaultNavigationBarHeight 44 // pixels

@interface CustomNavigationBar : UIView
{
	UIImageView* _backgroundImageView;
    
	
	UIView* _leftBarItemView;
	UIView* _rightBarItemView;
	
	UILabel* _titleLabel;
    UILabel* _longTitleLabel;
}

@property (nonatomic, assign) NSString* title;
@property (nonatomic, strong) UIView* leftBarItemView;
@property (nonatomic, strong) UIView* rightBarItemView;
@property (nonatomic, assign) UIImage* backgroundImage;

+ (UIButton*) createBarButtonWithTarget:(id <NSObject>)target 
								 action:(SEL)action
                        normalImageName:(NSString*)normalImageName
					   /*highlightedImage:(NSString*)highlightedImageName*/;

+ (UIButton*) returnBarButtonWithTarget:(id <NSObject>)target action:(SEL)action;
+ (UIButton*) refreshBarButtonWithTarget:(id <NSObject>)target action:(SEL)action;

- (void) setLongTitle:(NSString *)title;
- (id) initWithDefaultFrame;

@end
