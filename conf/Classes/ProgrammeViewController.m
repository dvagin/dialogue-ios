//
//  ProgrammeViewController.m
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "ProgrammeViewController.h"
#import "ListDataSource.h"
#import "DataManager.h"
#import "HallCell.h"
#import "DetailNewsViewController.h"
#import "ListDataSource.h"

@interface ProgrammeViewController ()

@end

@implementation ProgrammeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selector.dataSource = self;
    selector.delegate = self;
    
    selectedHall = [[[self realDataSource] hallsList] objectAtIndex:0];
    
    [selector reloadData];
    
    [self registerForNotifications];
    
    customNavigationBar.leftBarItemView = [CustomNavigationBar createBarButtonWithTarget:self action:@selector(goBack) normalImageName: @"backButton.png"];
}

- (void)viewDidUnload
{
    table = nil;
    selector = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDataSourceNotification:) name:kNotificationDataSourceUpdateIsCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDataSourceNotification:) name:kNotificationDataSourceUpdateIsFailed object:nil];
}

- (void) processDataSourceNotification:(NSNotification*)notification
{
    
    if ([notification.name isEqualToString:kNotificationDataSourceUpdateIsCompleted])
    {        
        if ([[notification object] class] == [ListDataSource class]) // notification for events
        {
            [self done];
            
        }
        
    }
    else //error
    {
        if ([[notification object] class] == [ListDataSource class]) // notification for events
        {
            //[self reloadCategoryData];
        }
    }
}

- (void) done
{
    [selector reloadData];
    [table reloadData];
}

#pragma mark - DataSource methods

- (BaseDataSource*) dataSource
{
    if (!_dataSource)
        _dataSource = [self createDataSource];
    
    return _dataSource;
}

- (ListDataSource*) realDataSource
{
    return (ListDataSource*)self.dataSource;
}

- (BaseDataSource*) createDataSource
{
    return (ListDataSource*)[DATA_MANAGER getDataSourceOfType:[ListDataSource class]];
}

- (NSArray*) dataForHall:(NSString*)hall
{
    return [NSMutableArray arrayWithArray:[[self realDataSource] dataForHallName:selectedHall]];
}

- (NSMutableArray*) daysForHall:(NSString*)hall
{
    if (!dataArray)
        dataArray = [NSMutableArray arrayWithArray:[[self realDataSource] daysForHallName:hall]];
    return dataArray;
}

- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self daysForHall:selectedHall] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id selectedObj = [[[[self dataForHall:selectedHall] objectAtIndex:section] objectForKey:@"Date"] objectForKey:@"Session"];
    
    if ([selectedObj isKindOfClass:[NSDictionary class]])
        return 1;
    else
        return [selectedObj count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    HallCell *cell = (HallCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HallCell"owner:self options:nil] objectAtIndex:0];
    
    id selectedObj = [[[[self dataForHall:selectedHall] objectAtIndex:indexPath.section] objectForKey:@"Date"] objectForKey:@"Session"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    if ([selectedObj isKindOfClass:[NSDictionary class]])
    {
        cell.titleLabel.text = [selectedObj objectForKey:@"Session"];
        cell.timeLabel.text = [selectedObj objectForKey:@"Time"];

    }
    else
    {
        cell.titleLabel.text = [[selectedObj objectAtIndex:indexPath.row] objectForKey:@"Session"];
        cell.timeLabel.text = [[selectedObj objectAtIndex:indexPath.row] objectForKey:@"Time"];

    }
    
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self daysForHall:selectedHall] objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * url;
    NSString * title;
	
    id selectedObj = [[[[self dataForHall:selectedHall] objectAtIndex:indexPath.section] objectForKey:@"Date"] objectForKey:@"Session"];
    if ([selectedObj isKindOfClass:[NSDictionary class]])
    {
        url = [selectedObj objectForKey:@"id"];
        title = [selectedObj objectForKey:@"Session"];

    }
    else
    {
        url = [[selectedObj objectAtIndex:indexPath.row] objectForKey:@"id"];
        title = [[selectedObj objectAtIndex:indexPath.row] objectForKey:@"Session"];
    }

    NSString * urlString = [NSString stringWithFormat:@"http://rhodesforum.org/mobile/%@.html",url];
    NSURL * currUrl = [NSURL URLWithString:urlString];
    
    DetailNewsViewController* dvc = [[DetailNewsViewController alloc] initWithURL:currUrl];
    dvc.title = title;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    header.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hallButton.png"]];
    
    headerImage.alpha = MAX( 0.9 - section * 0.1 , 0.7);
    
    [header addSubview:headerImage];
    
    UILabel * headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 37)];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.textColor = [UIColor whiteColor];
    headerTitle.font = [UIFont boldSystemFontOfSize:18.0f];
    headerTitle.text = sectionTitle;
    [header addSubview:headerTitle];
    
    return header;

}


#pragma mark - selector DataSource

-(NSInteger) numberOfElementsInSelector:(HallSelector*)selector
{
    return [[[self realDataSource] hallsList] count];
}

-(NSString*) titleForElementInSelector:(HallSelector*)selector atIndex:(NSInteger)index
{
    return [[[self realDataSource] hallsList] objectAtIndex:index];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) didSelelctElement:(NSInteger)index InSelector:(HallSelector *)selector
{
    selectedHall = [[[self realDataSource] hallsList] objectAtIndex:index];
    dataArray = nil;
    [table reloadData];
}

@end
