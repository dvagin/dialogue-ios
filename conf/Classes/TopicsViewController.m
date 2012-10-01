//
//  TopicsViewController.m
//  conf
//
//  Created by Sergey Vishnyov on 9/27/12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "TopicsViewController.h"
#import "NewsViewController.h"
#import "TopicsCell.h"

@interface TopicsViewController ()

@end

@implementation TopicsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Topics";
        self.tabBarItem.title = self.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    m_politics = nil;
    m_economics = nil;
    m_society = nil;
    [super viewDidUnload];
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TopicsCell *cell = (TopicsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TopicsCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Politics";
            cell.icon.image = [UIImage imageNamed:@"topicsIcon1.png"];
            break;
        case 1:
            cell.textLabel.text = @"Economics";
            cell.icon.image = [UIImage imageNamed:@"topicsIcon2.png"];
            break;
        case 2:
            cell.textLabel.text = @"Society";
            cell.icon.image = [UIImage imageNamed:@"topicsIcon3.png"];
            break;
        case 3:
            cell.textLabel.text = @"Events";
            cell.icon.image = [UIImage imageNamed:@"topicsIcon4.png"];
            break;
            
        default:
            break;
    }
    
    cell.bg.alpha = 1 - indexPath.row * 0.1;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsViewController * nvc = [[NewsViewController alloc] initWithRssType:indexPath.row + 1];
    [self.navigationController pushViewController:nvc animated:YES];
}


-(IBAction)mainScreenButtonsPressed:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1:{
            NSLog(@"%i", button.tag);
            NewsViewController* news = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
//            news.arrayOfNews = nil;
            [self.navigationController pushViewController:news animated:YES];
            break;
        }
        case 2:
            NSLog(@"%i", button.tag);
            break;
        case 3:
            NSLog(@"%i", button.tag);
            break;
        default:
            break;
    }
}

@end
