
//

#import "BaseViewController.h"

@implementation BaseViewController

@dynamic customNavigationBar;
@dynamic dataSource;
@synthesize reloadDataSourceOnViewUpdate;
@synthesize animateDataSourceActivity;
@dynamic leftBarButtonType, rightBarButtonType;
@dynamic navigationBarTitle;

- (void) registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDataSourceNotification:) name:kNotificationDataSourceUpdateIsCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDataSourceNotification:) name:kNotificationDataSourceUpdateIsFailed object:nil];
}

- (id) init
{
    if (self = [super init])
    {
        [self registerForNotifications];
        self.reloadDataSourceOnViewUpdate = NO;
        self.animateDataSourceActivity = YES;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self registerForNotifications];
        self.reloadDataSourceOnViewUpdate = NO;
        self.animateDataSourceActivity = YES;
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_activityIndicatorView release];
    [_rightBarItemView release];
    [_customNavigationBar release];
    [_dataSource release];
    [_navigationBarTitle release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Properties

- (CustomNavigationBar*) customNavigationBar
{
    if (!_customNavigationBar)
        _customNavigationBar = [[CustomNavigationBar alloc] initWithDefaultFrame];
    
    return _customNavigationBar;
}

- (BaseDataSource*) dataSource
{
    if (!_dataSource)
        _dataSource = [self createDataSource];
    
    return _dataSource;
}

- (UIButton*) buttonForBarButtonType:(CustomNavigatioBarButtonType)barButtonType
{
    if (barButtonType == BarButtonBackwards)
        return [CustomNavigationBar createBarButtonWithTarget:self action:@selector(goBack) normalImageName:@"back_button_return_a.png"];

    if (barButtonType == BarButtonMatches)
        return [CustomNavigationBar createBarButtonWithTarget:self action:@selector(goBack) normalImageName:@"back_button_matches_a.png"];
    
    if (barButtonType == BarButtonRefresh)
        return [CustomNavigationBar createBarButtonWithTarget:self action:@selector(reloadDataSource) normalImageName:@"navbar_button_refresh_a.png"];
    
    return nil; // barButtonType == BarButtonNone or anything else.
}

- (void) setLeftBarButtonType:(CustomNavigatioBarButtonType)leftBarButtonType
{
    self.customNavigationBar.leftBarItemView = [self buttonForBarButtonType:leftBarButtonType];
}

- (void) setRightBarButtonType:(CustomNavigatioBarButtonType)rightBarButtonType
{
    self.customNavigationBar.rightBarItemView = [self buttonForBarButtonType:rightBarButtonType];   
}

- (void) setNavigationBarTitle:(NSString *)navigationBarTitle
{
    [_navigationBarTitle release];
    _navigationBarTitle = [navigationBarTitle copy];
    
    if (self.customNavigationBar)
        self.customNavigationBar.title = _navigationBarTitle;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.customNavigationBar];
    self.customNavigationBar.title = _navigationBarTitle;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [_customNavigationBar release];
    _customNavigationBar = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.reloadDataSourceOnViewUpdate || !self.dataSource.hasData)
        [self reloadDataSource];
    else
        [self updateView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - DataSource

- (void) dataSourceWillStartLoading
{
    if (self.animateDataSourceActivity)
        [self showActivityIndicator];
}

- (void) dataSourceDidCompleteLoading
{
    if (self.animateDataSourceActivity)
        [self hideActivityIndicator];
}

- (void) dataSourceDidUpdate
{
    [self updateView];
}

- (void) dataSourceUpdateDidFail
{
    [self updateView];
}

- (void) processDataSourceNotification:(NSNotification*)notification
{
    [self dataSourceDidCompleteLoading];
    
    if (!((BaseDataSource*)[notification object] == _dataSource))
        return;
    
    if ([notification.name isEqualToString:kNotificationDataSourceUpdateIsFailed])
    {
        [self dataSourceUpdateDidFail];
        return;
    }
    
    if ([notification.name isEqualToString:kNotificationDataSourceUpdateIsCompleted] && _dataSource.hasReallyNewItems)
    {
        [self dataSourceDidUpdate];
    }
}

#pragma mark - Navigation

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Methods

- (BaseDataSource*) createDataSource
{
    return nil;
}

- (void) updateView
{
    
}

- (void) reloadDataSource
{
    [self dataSourceWillStartLoading];
    [self.dataSource update];
}

#pragma mark - Activity indicator

- (void) showActivityIndicator
{
    if (!_activityIndicatorView)
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if (!self.customNavigationBar.rightBarItemView && _rightBarItemView)
    {
        [_rightBarItemView release];
        _rightBarItemView = nil;
    }
    else if (self.customNavigationBar.rightBarItemView != _rightBarItemView &&
             self.customNavigationBar.rightBarItemView != _activityIndicatorView)
    {
        [_rightBarItemView release];
        _rightBarItemView = [self.customNavigationBar.rightBarItemView retain];
    }
    
    [_activityIndicatorView startAnimating];
    
    self.customNavigationBar.rightBarItemView = _activityIndicatorView;
}

- (void) hideActivityIndicator
{
    if (!_activityIndicatorView)
        return;
    
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView release];
    _activityIndicatorView = nil;
    
    self.customNavigationBar.rightBarItemView = _rightBarItemView;
    [_rightBarItemView release];
    _rightBarItemView = nil;
}

@end
