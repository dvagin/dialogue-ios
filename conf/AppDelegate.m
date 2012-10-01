//
//  AppDelegate.m
//  conf
//
//  Created by Sergey Vishnyov on 9/27/12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsViewController.h"
#import "TopicsViewController.h"
#import "ForumViewController.h"
#import "AboutViewController.h"
#import "DataManager.h"
#import "ListDataSource.h"
#import "RSSDataSource.h"

@implementation AppDelegate
@synthesize tabBarController = _tabBarController;
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initialLoadData];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *viewControllerNews = [[UINavigationController alloc] initWithRootViewController: [[NewsViewController alloc] initWithRssType:rssDataTypeNews]];
    
    viewControllerNews.tabBarItem = [[UITabBarItem alloc]
                                     initWithTitle:NSLocalizedString(@"News", @"News")
                                     image:[UIImage imageNamed:@"tabItm1.png"]
                                     tag:0];
    
    UIViewController *viewControllerTopics = [[TopicsViewController alloc] initWithNibName:@"TopicsViewController" bundle:nil];
    
    viewControllerTopics.tabBarItem = [[UITabBarItem alloc]
                                     initWithTitle:NSLocalizedString(@"Topics", @"Topics")
                                     image:[UIImage imageNamed:@"tabItm2.png"]
                                     tag:1];
    
    UIViewController *navControllerTopics = [[UINavigationController alloc] initWithRootViewController:viewControllerTopics];
    UIViewController *viewControllerForum = [[ForumViewController alloc] initWithNibName:@"ForumViewController" bundle:nil];
    
    viewControllerForum.tabBarItem = [[UITabBarItem alloc]
                                       initWithTitle:NSLocalizedString(@"Forum", @"Forum")
                                       image:[UIImage imageNamed:@"tabItm3.png"]
                                       tag:2];

    
    UIViewController *navControllerForum = [[UINavigationController alloc] initWithRootViewController:viewControllerForum];
    UIViewController *viewControllerAbout = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    
    viewControllerAbout.tabBarItem = [[UITabBarItem alloc]
                                     initWithTitle:NSLocalizedString(@"About", @"About")
                                     image:[UIImage imageNamed:@"tabItm4.png"]
                                     tag:3];
    
    UIViewController *navControllerAbout = [[UINavigationController alloc] initWithRootViewController:viewControllerAbout];
    
       self.tabBarController = [[UITabBarController alloc] init];

    if ([[UITabBar class]respondsToSelector:@selector(appearance)]) {
        [[UITabBar appearance] setBackgroundColor:[UIColor cyanColor]];
    }

    [self.tabBarController.tabBar setBackgroundColor:[UIColor redColor]];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewControllerNews, navControllerTopics, navControllerForum, navControllerAbout, nil];
    [self.tabBarController setSelectedViewController:viewControllerNews];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void) initialLoadData
{
    [DATA_MANAGER getDataSourceOfType:[ListDataSource class]];
    [DATA_MANAGER getDataSourceOfType:[RSSDataSource class] rssType:rssDataTypeNews];
    [DATA_MANAGER getDataSourceOfType:[RSSDataSource class] rssType:rssDataTypeSociety];
        [DATA_MANAGER getDataSourceOfType:[RSSDataSource class] rssType:rssDataTypePolitics];
        [DATA_MANAGER getDataSourceOfType:[RSSDataSource class] rssType:rssDataTypeEvents];
        [DATA_MANAGER getDataSourceOfType:[RSSDataSource class] rssType:rssDataTypeEconomics];
    [DATA_MANAGER updateAllDataSources];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
