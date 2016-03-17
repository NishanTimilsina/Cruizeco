//
//  SidebarViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/4/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "SidebarViewController.h"
#import "SidebarTableViewCell.h"


#import "AppDelegate.h"

@interface SidebarViewController ()

@property (strong, nonatomic) NSMutableArray* menuIcons;
@property (strong, nonatomic) NSMutableArray* menuTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonSOS;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogout;

@end

static NSString* kCellIdentifier = @"SidebarTableViewCell";

static NSString* kImageDisclosureArrowNormal= @"arrow-normal.png";
static NSString* kImageDisclosureArrowHover= @"arrow-hover.png";

static NSString* kIconMenuMyProfile= @"my-profile-icon.png";
static NSString* kIconMenuFriends= @"friends-menu-icon.png";
static NSString* kIconMenuGroups= @"groups-icon.png";
static NSString* kIconMenuEvents= @"events-icon.png";
static NSString* kIconMenuRoutes= @"routes-icon.png";
static NSString* kIconMenuSettings= @"settings-icon.png";

static NSString* kTitleMenuMyProfile= @"My Profile";
static NSString* kTitleMenuFriends= @"Notifications";
static NSString* kTitleMenuGroups= @"Groups";
static NSString* kTitleMenuEvents= @"Events";
static NSString* kTitleMenuRoutes= @"Routes";
static NSString* kTitleMenuSettings= @"Settings";

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareContents];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    
    [self perkUI];
}

-(void) perkUI {
    self.buttonLogout.layer.cornerRadius= CGRectGetHeight(self.buttonLogout.frame) / 2.0;
    self.buttonLogout.layer.borderWidth= 1.0f;
    self.buttonLogout.layer.borderColor= [UIColor clearColor].CGColor;
    [self.buttonLogout setClipsToBounds:YES];
    
    self.buttonSOS.layer.cornerRadius= CGRectGetHeight(self.buttonSOS.frame) / 2.0;
    
}

-(void) prepareContents {
    self.menuIcons= [[NSMutableArray alloc] initWithObjects:kIconMenuMyProfile, kIconMenuFriends, kIconMenuEvents, kIconMenuGroups, kIconMenuRoutes, kIconMenuSettings, nil];
    
    self.menuTitles= [[NSMutableArray alloc] initWithObjects:kTitleMenuMyProfile, kTitleMenuFriends, kTitleMenuGroups, kTitleMenuEvents, kTitleMenuRoutes, kTitleMenuSettings, nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    return [self.menuIcons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 5;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSString* openIndicator= ([self.tableView isOpenSection:section])? @"-": @"+";
//    UILabel* titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
//    [titleLabel setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
//    titleLabel.text= [NSString stringWithFormat:@"  [%@] %@ x %@", openIndicator, [[[[self.response objectForKey:@"item_details"] objectAtIndex:section] objectForKey:@"itemDetail"] objectForKey:@"quantity"], [[[[self.response objectForKey:@"item_details"] objectAtIndex:section] objectForKey:@"itemDetail"] objectForKey:@"name"]];
//    
//    
//    titleLabel.font= [UIFont fontWithName:@"Helvetica Neue" size:15.0];
//    [titleLabel sizeToFit];
//    [titleLabel setFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width + 10.0, titleLabel.frame.size.height + 30.0)];
//    UIView* headerView= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, titleLabel.frame.size.width, titleLabel.frame.size.height+10.0)];
//    [headerView addSubview:titleLabel];
//    
//    return headerView;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.row == 0) {
       [appDelegate changeToProfileView];
    } else if (indexPath.row == 2) {
        [appDelegate changeToGroupsView];
    } else if (indexPath.row == 3) {
        [appDelegate changeToEventsView];
    } else if (indexPath.row == 4) {
        [appDelegate changeToRoutesView];
    }
    
    

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    SidebarTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell)
    {
        cell = [[SidebarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    if (![cell.labelTitle.text isEqualToString:@"Label"]) {
        return cell;
    }
    
    [cell.ivIcon setImage:[UIImage imageNamed:[self.menuIcons objectAtIndex:indexPath.row]]];
    [cell.labelTitle setText:[self.menuTitles objectAtIndex:indexPath.row]];
    [cell.ivArrow setImage:[UIImage imageNamed:kImageDisclosureArrowNormal]];
    
    UIView* borderView= [[UIView alloc] initWithFrame:CGRectMake(10.0, 45.0, 250, 2.0)];
    borderView.backgroundColor= [UIColor lightGrayColor];
    borderView.alpha= 0.1;
    
    [cell.contentView addSubview:borderView];
    return cell;
}


- (IBAction)showFriends:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate changeToFriendsView];
}

@end
