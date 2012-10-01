//
//  NewsViewController.m
//  conf
//
//  Created by Sergey Vishnyov on 9/27/12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "NewsViewController.h"
#import "DetailNewsViewController.h"
#import "RSSDataSource.h"


@interface NewsViewController ()

@end

@implementation NewsViewController
@synthesize arrayOfNews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id) initWithRssType:(rssDataType)type
{
    currentType = type;
    
    switch (currentType) {
        case rssDataTypeNews:
            self.title = @"News";
            break;
        case rssDataTypeEconomics:
            self.title = @"Economics";
            break;
        case rssDataTypeEvents:
            self.title = @"Events";
            break;
        case rssDataTypePolitics:
            self.title = @"Politics";
            break;
        case rssDataTypeSociety:
            self.title = @"Society";
            break;
    }
    
    self.tabBarItem.title = self.title;
    
    return [self initWithNibName:@"NewsViewController" bundle:[NSBundle mainBundle]];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self registerForNotifications];
    
    if (currentType != rssDataTypeNews)
        customNavigationBar.leftBarItemView = [CustomNavigationBar createBarButtonWithTarget:self action:@selector(goBack) normalImageName: @"backButton.png"];
}

#pragma mark - DataSource methods

- (BaseDataSource*) dataSource
{
    if (!_dataSource)
        _dataSource = [self createDataSource];
    
    return _dataSource;
}

- (RSSDataSource*) realDataSource
{
    return (RSSDataSource*)self.dataSource;
}

- (BaseDataSource*) createDataSource
{
    return (RSSDataSource*)[DATA_MANAGER getDataSourceOfType:[RSSDataSource class] rssType:currentType];
}

#pragma mark - Notifications methods

- (void) registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDataSourceNotification:) name:kNotificationDataSourceUpdateIsCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDataSourceNotification:) name:kNotificationDataSourceUpdateIsFailed object:nil];
}

- (void) processDataSourceNotification:(NSNotification*)notification
{
    
    if ([notification.name isEqualToString:kNotificationDataSourceUpdateIsCompleted])
    {        
        if ([[notification object] class] == [RSSDataSource class]) // notification for events
        {
            [self done];
            
        }
        
    }
    else //error
    {
        if ([[notification object] class] == [RSSDataSource class]) // notification for events
        {
            //[self reloadCategoryData];
        }
    }
}

- (NSArray*) items
{
    return [[self realDataSource] mainItems];
}

- (void) done
{
    [table reloadData];
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NewsCell *cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
//        cell.readButton.tag = indexPath.row;
//        [cell.readButton addTarget:self action:@selector(readButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.authorNameLabel.text = [[self realDataSource] authorAtIndex:indexPath.row];
    cell.dateOfPublicationLabel.text = [[self realDataSource] publicDateAtIndex:indexPath.row];
    cell.nameOfTopicLabel.text = [[self realDataSource] titleAtIndex:indexPath.row];

    cell.imageView.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showNewsAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) showNewsAtIndex:(NSInteger)index
{
    NSString * body = [[self realDataSource] htmlBodyAtIndex:index];
    
    DetailNewsViewController* dvc = [[DetailNewsViewController alloc] initWithBody:body];
    dvc.title = [[self realDataSource] titleAtIndex:index];
    dvc.externalLink = [[self realDataSource] linkAtIndex:index];
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - Main Methods


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
