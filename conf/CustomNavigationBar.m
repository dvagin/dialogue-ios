
//

#import "CustomNavigationBar.h"
#import "MyDebug.h"


#define kNavigationBarItemHorizontalMargin 5
#define kTitleHorizontalMargin 5
#define kTopMargin -1

@implementation CustomNavigationBar

@dynamic title, leftBarItemView, rightBarItemView;
@dynamic backgroundImage;

+ (UIButton*) createBarButtonWithTarget:(id <NSObject>)target 
								 action:(SEL)action
                        normalImageName:(NSString*)normalImageName
//highlightedImage:(NSString*)highlightedImageName
{
	UIImage* normalImage = (normalImageName ? [UIImage imageNamed:normalImageName] : nil);
	//UIImage* highlightedImage = (highlightedImageName ? [UIImage imageNamed:highlightedImageName] : nil);
	
	if (!normalImage/* || !highlightedImageName*/)
	{
		NSString* errorMessage = [NSString stringWithFormat:@"The following image does't exist in the app bundle: %@.",
                                  normalImageName];
        MethodError(@"createBarButtonWithTarget:action:normalImage:highlightedImage:", errorMessage);
		return nil;
	}
	
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, normalImage.size.width, normalImage.size.height)];
    [button setImage:normalImage forState:UIControlStateNormal];
    
	if (target && action && [target respondsToSelector:action])
		[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	return  button;
}

+ (UIButton*) returnBarButtonWithTarget:(id <NSObject>)target action:(SEL)action
{
    return [self createBarButtonWithTarget:target action:action normalImageName:@"backButton.png"];
}

+ (UIButton*) refreshBarButtonWithTarget:(id <NSObject>)target action:(SEL)action
{
    return [self createBarButtonWithTarget:target action:action normalImageName:@"navbar_button_refresh_a.png"];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
		CGRect bounds = frame;
		bounds.origin = CGPointZero;
		
        self.backgroundColor = [UIColor clearColor];
        
		_backgroundImageView = [[UIImageView alloc] initWithFrame:bounds]; 
		_backgroundImageView.image = [UIImage imageNamed:@"navbar.png"];
		[self addSubview:_backgroundImageView];
		
		_titleLabel = [[UILabel alloc] initWithFrame:bounds];
		_titleLabel.font = [UIFont boldSystemFontOfSize:20];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.shadowColor = [UIColor darkGrayColor];
		_titleLabel.shadowOffset = CGSizeMake(0, -1);
		_titleLabel.textAlignment = UITextAlignmentCenter;
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _titleLabel.numberOfLines = 1;
		[self addSubview:_titleLabel];
    }
	
    return self;
}

- (id) initWithDefaultFrame
{
	return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, kDefaultNavigationBarHeight)];
}

- (void) dealloc
{

}

- (void) setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImageView.image = backgroundImage;
}

- (void) layoutUI
{
    if (!_leftBarItemView && !_rightBarItemView && !_titleLabel)
        return;
    
    CGSize fullSize = self.bounds.size;
    CGFloat availableWidth = fullSize.width;
    
    if (_leftBarItemView)
    {
        _leftBarItemView.center = self.center;
        
        CGRect leftViewFrame = _leftBarItemView.frame;
        leftViewFrame.origin.y += kTopMargin - (self.bounds.size.height - kDefaultNavigationBarHeight) / 2;
        leftViewFrame.origin.x = kNavigationBarItemHorizontalMargin;
        _leftBarItemView.frame = leftViewFrame;
        
        availableWidth -= leftViewFrame.origin.x + leftViewFrame.size.width;
    }
    
    if (_rightBarItemView)
    {
        _rightBarItemView.center = self.center;
        
        CGRect rightViewFrame = _rightBarItemView.frame;
        rightViewFrame.origin.y += kTopMargin - (self.bounds.size.height - kDefaultNavigationBarHeight) / 2;
        rightViewFrame.origin.x = fullSize.width - kNavigationBarItemHorizontalMargin - rightViewFrame.size.width;
        _rightBarItemView.frame = rightViewFrame;
        
        availableWidth -= kNavigationBarItemHorizontalMargin + rightViewFrame.size.width;
    }
    
    if (_titleLabel)
    {
        availableWidth -= kTitleHorizontalMargin * 2;
        
        _titleLabel.center = self.center;
        
        CGRect labelFrame = _titleLabel.frame;
//        labelFrame.size = [_titleLabel requiredSizeConstrainedToSize:fullSize];
        labelFrame.origin.y = (fullSize.height - labelFrame.size.height) / 2 + kTopMargin - (self.bounds.size.height - kDefaultNavigationBarHeight) / 2;
        
        BOOL needLayOut = availableWidth < labelFrame.size.width;
        
        if (!needLayOut && (_leftBarItemView || _rightBarItemView))
        {
            CGFloat freeSideWidth = (fullSize.width - labelFrame.size.width) / 2 - kTitleHorizontalMargin;
            
            if (_leftBarItemView && (freeSideWidth < _leftBarItemView.frame.size.width + kNavigationBarItemHorizontalMargin))
                needLayOut = YES;
            else if (_rightBarItemView && freeSideWidth < _rightBarItemView.frame.size.width + kNavigationBarItemHorizontalMargin)
                needLayOut = YES;
        }
        
        if (needLayOut)
        {
            CGFloat currentLabelWidth = labelFrame.size.width;
            
            if (_leftBarItemView)
            {
                _titleLabel.backgroundColor = [UIColor clearColor];
                labelFrame.origin.x = _leftBarItemView.frame.origin.x + _leftBarItemView.frame.size.width + kTitleHorizontalMargin;
                labelFrame.size.width = 200;
            }
            else if (_rightBarItemView)
            {
                labelFrame.origin.x = _rightBarItemView.frame.origin.x - kTitleHorizontalMargin;
                labelFrame.size.width = currentLabelWidth;
            }
            else
            {
                labelFrame.origin.x = kTitleHorizontalMargin;
                labelFrame.size.width = availableWidth;
            }
        }
        else
        {
            labelFrame.size.width = self.bounds.size.width;
            labelFrame.origin.x = 0;
        }        
        
        _titleLabel.frame = labelFrame;
    }
}

#pragma mark - properties

- (void) setTitle:(NSString *)title
{
	_titleLabel.text = title;
}

- (void) setBarItemView:(UIView*)view currentView:(UIView*)currentView
{
	if (currentView)
		[currentView removeFromSuperview];
	
	if (view)
	{
		currentView = view;
		[self addSubview:currentView];
	}
    
    [self layoutUI];
}

- (UIView*) leftBarItemView
{
    return _leftBarItemView;
}

- (void) setLeftBarItemView:(UIView *)leftBarItemView
{
    if (_leftBarItemView)
    {
        [_leftBarItemView removeFromSuperview];
        _leftBarItemView = nil;
    }
	
	if (leftBarItemView)
	{
        [self addSubview:leftBarItemView];
		_leftBarItemView = leftBarItemView;
	}
    
    [self layoutUI];
}

- (UIView*) rightBarItemView
{
    return _rightBarItemView;
}

- (void) setRightBarItemView:(UIView *)rightBarItemView
{
	if (_rightBarItemView)
    {
        [_rightBarItemView removeFromSuperview];
        _rightBarItemView = nil;
    }
	
	if (rightBarItemView)
	{
        [self addSubview:rightBarItemView];
		_rightBarItemView = rightBarItemView;
	}
    
    [self layoutUI];
}

@end
