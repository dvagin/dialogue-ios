//
//  ForumViewController.m
//  conf
//
//  Created by Sergey Vishnyov on 9/27/12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "ForumViewController.h"
#import "DetailNewsViewController.h"
#import "Base64.h"
#import "ProgrammeViewController.h"
#import "ProgrammCell.h"


#define kMediaStreamLink @"http://www.rhodesforum.org/online/"

@interface ForumViewController ()

@end

@implementation ForumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Forum";
        self.tabBarItem.title = self.title;
        [self performSelectorInBackground:@selector(prepareImage) withObject:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) prepareImage
{
    UIImage * scheme = [UIImage imageNamed:@"scheme.jpg"];
    NSData * imageData = UIImagePNGRepresentation(scheme);    
    imageSource = [NSString stringWithFormat:@"data:image/png;base64,%@",[imageData base64Encoding]];
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height/3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cells";
    
    ProgrammCell *cell = (ProgrammCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) 
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProgrammCell"owner:self options:nil] objectAtIndex:0];
        
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [cell setCellHeight:tableView.frame.size.height/3];
    
    cell.bg.alpha = 1 - indexPath.row * 0.1;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Programme";
            break;
        case 1:
            cell.textLabel.text = @"Halls";
            break;
        case 2:
            cell.textLabel.text = @"Videostream";
            break;
            
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            ProgrammeViewController * pvc = [[ProgrammeViewController alloc] initWithNibName:@"ProgrammeViewController" bundle:[NSBundle mainBundle]];   
            pvc.title = @"Programme";
            [self.navigationController pushViewController:pvc animated:YES];
            
            break;
        }
        case 1:
        {
            
            
            NSString * body = [NSString stringWithFormat:@"<img src='%@' />", imageSource];
            
            DetailNewsViewController* hvc = [[DetailNewsViewController alloc] initWithImage64:body];
            hvc.title = @"Halls";
            
            [self.navigationController pushViewController:hvc animated:YES];
            //
            break;
        }
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kMediaStreamLink]];
            break;
            
        default:
            break;
    }
}

@end
