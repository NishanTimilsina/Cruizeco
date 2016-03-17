//
//  AppDelegate.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "AppDelegate.h"
#import "PKRevealController.h"
#import "SidebarViewController.h"
#import "ProfileViewController.h"
#import "MyEventsViewController.h"
#import "TracksListViewController.h"
#import "FriendsViewController.h"

#import "GroupsListViewController.h"

@import GoogleMaps;

@interface AppDelegate ()



@property (nonatomic, strong, readwrite) PKRevealController *revealController;

@property (nonatomic, strong) UINavigationController* navigationController;

@property (nonatomic, strong) SidebarViewController *leftViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Step 1: Create your controllers.
    
    
    [GMSServices provideAPIKey:@"AIzaSyAx8s9JkWM3xWXDQ0QCP66tlSnioGqnaw8"];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    ProfileViewController *frontViewController = (ProfileViewController*)[mainStoryboard
                                                                         instantiateViewControllerWithIdentifier: @"ProfileVC"];

    MyEventsViewController* myEventsVC= (MyEventsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MyEventsVC"];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:myEventsVC];
   
    
    [myEventsVC.navigationItem setLeftBarButtonItem:[self showSidebarButton]];
    
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:18/255.0 green:168/255.0 blue:171/255.0 alpha:1.0]];
    
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    myEventsVC.navigationController.navigationBar.translucent= NO;
//    myEventsVC.navigationController.navigationBar.backgroundColor= [UIColor orangeColor];

    // Step 2: Instantiate.
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:self.navigationController leftViewController:[self leftViewController]];
    // Step 3: Configure.
    self.revealController.delegate = self.navigationController;
    self.revealController.animationDuration = 0.25;
    [self.revealController setProvidesPresentationContextTransitionStyle:YES];
    [self.revealController setMinimumWidth:270.0 maximumWidth:270.0 forViewController:[self leftViewController]];
    
    // Step 4: Apply.
    self.window.rootViewController = self.revealController;
    
    [self.window makeKeyAndVisible];
    
    [UITableView appearance].sectionIndexColor = [UIColor colorWithRed:18/255.0 green:168/255.0 blue:171/255.0 alpha:1.0];

    // 18 168 171
    return YES;
}

-(void) changeToProfileView {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    ProfileViewController *frontViewController = (ProfileViewController*)[mainStoryboard
                                                                          instantiateViewControllerWithIdentifier: @"ProfileVC"];
    
    MyEventsViewController* myEventsVC= (MyEventsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MyEventsVC"];
    

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [frontViewController.navigationItem setLeftBarButtonItem:[self showSidebarButton]];
    [self.revealController setFrontViewController:self.navigationController];
    
    [self.revealController showViewController:self.revealController.frontViewController];

}

-(UIBarButtonItem*) showSidebarButton {
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor= [UIColor orangeColor];
    UIImage* barButtonImage= [UIImage imageNamed:@"add-more-below-icon.png"];
    [button setImage:barButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, barButtonImage.size.width+5.0, barButtonImage.size.height+5.0)];
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 50, 20)];
    //    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
    //    [label setText:title];
    //    label.textAlignment = UITextAlignmentCenter;
    //    [label setTextColor:[UIColor whiteColor]];
    //    [label setBackgroundColor:[UIColor clearColor]];
    //    [button addSubview:label];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    

}

-(void) buttonAction:(id) sender {
    [self.revealController enterPresentationModeAnimated:YES completion:nil];
}


-(void) changeToGroupsView {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    GroupsListViewController* groupsListVC= (GroupsListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"GroupsListVC"];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:groupsListVC];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [groupsListVC.navigationItem setLeftBarButtonItem:[self showSidebarButton]];
    [self.revealController setFrontViewController:self.navigationController];
    
    [self.revealController showViewController:self.revealController.frontViewController];
    
}

-(void) changeToFriendsView {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    FriendsViewController* friendsVC= (FriendsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsVC"];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:friendsVC];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [friendsVC.navigationItem setLeftBarButtonItem:[self showSidebarButton]];
    [self.revealController setFrontViewController:self.navigationController];
    
    [self.revealController showViewController:self.revealController.frontViewController];
    
}


-(void) changeToEventsView {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    MyEventsViewController* myEventsVC= (MyEventsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MyEventsVC"];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:myEventsVC];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [myEventsVC.navigationItem setLeftBarButtonItem:[self showSidebarButton]];
    [self.revealController setFrontViewController:self.navigationController];
    
    [self.revealController showViewController:self.revealController.frontViewController];
    
}

-(void) changeToRoutesView {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    TracksListViewController* tracksVC= (TracksListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"TracksListVC"];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:tracksVC];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [tracksVC.navigationItem setLeftBarButtonItem:[self showSidebarButton]];
    [self.revealController setFrontViewController:self.navigationController];
    
    [self.revealController showViewController:self.revealController.frontViewController];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - PKRevealing

- (void)revealController:(PKRevealController *)revealController didChangeToState:(PKRevealControllerState)state
{
    NSLog(@"%@ (%d)", NSStringFromSelector(_cmd), (int)state);
}

- (void)revealController:(PKRevealController *)revealController willChangeToState:(PKRevealControllerState)next
{
    PKRevealControllerState current = revealController.state;
    NSLog(@"%@ (%d -> %d)", NSStringFromSelector(_cmd), (int)current, (int)next);
}

#pragma mark - Helpers

- (UIViewController *)leftViewController
{
    
    if (!_leftViewController) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        _leftViewController = (SidebarViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"SidebarVC"];
    }
    return _leftViewController;
}



- (void)startPresentationMode
{
    if (![self.revealController isPresentationModeActive])
    {
        [self.revealController enterPresentationModeAnimated:YES completion:nil];
    }
    else
    {
        [self.revealController resignPresentationModeEntirely:NO animated:YES completion:nil];
    }
}


@end
