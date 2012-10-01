
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBar.h"
#import "BaseDataSource.h"

typedef enum
{
    BarButtonNone = 0,
    BarButtonRefresh = 1,
    BarButtonBackwards = 2,
    BarButtonMatches = 3,
    
} CustomNavigatioBarButtonType;


@interface BaseViewController : UIViewController
{
@private
    CustomNavigationBar* _customNavigationBar;
    BaseDataSource* _dataSource;
    
    UIActivityIndicatorView* _activityIndicatorView;
    UIView* _rightBarItemView;
    
    BOOL reloadDataSourceOnViewUpdate;
    BOOL animateDataSourceActivity;
    
    NSString* _navigationBarTitle;
}

@property (nonatomic, readonly) CustomNavigationBar* customNavigationBar;
@property (nonatomic, readonly) BaseDataSource* dataSource;
@property (nonatomic, readwrite) BOOL reloadDataSourceOnViewUpdate;
@property (nonatomic, readwrite) BOOL animateDataSourceActivity;

@property (nonatomic, assign) CustomNavigatioBarButtonType leftBarButtonType;
@property (nonatomic, assign) CustomNavigatioBarButtonType rightBarButtonType;
@property (nonatomic, copy) NSString* navigationBarTitle;

- (void) goBack;

- (void) registerForNotifications;

- (BaseDataSource*) createDataSource;

- (void) updateView;
- (void) reloadDataSource;

- (void) dataSourceWillStartLoading;
- (void) dataSourceDidCompleteLoading;
- (void) dataSourceDidUpdate;
- (void) dataSourceUpdateDidFail;

- (void) showActivityIndicator;
- (void) hideActivityIndicator;

@end
