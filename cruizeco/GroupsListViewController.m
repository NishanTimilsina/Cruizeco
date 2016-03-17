//
//  GroupsListViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 8/18/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "GroupsListViewController.h"


#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

#import "EventTableViewCell.h"

#import "GroupInfo.h"
#import "GroupDetailViewController.h"
#import <CMPopTipView.h>
#import "UIButton+Block.h"

#import "CreateGroupViewController.h"

enum displayGroup{
    kMyGroup,
    kPublicGroup,
    kAdminedGroup
} ;

@interface GroupsListViewController ()


/**
 Drop down menu from right bar button
 */
@property (strong, nonatomic) CMPopTipView* popTipView;

/**
 Currently showing Group
 */
@property NSInteger displayGroup;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray* groups;
@property (strong, nonatomic) NSString* navigationTitle;

@end

static NSString* cellIdentifier = @"MyEventsTableViewCell";
static NSString* kMembersText= @"";

@implementation GroupsListViewController

-(NSString*) navigationTitle {
    if (!_navigationTitle) {
        _navigationTitle= @"My Groups";
    }
    return _navigationTitle;
}

-(NSMutableArray*) groups {
    if (!_groups) {
        _groups= [[NSMutableArray alloc] init];
    }
    return _groups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getGroups];
    self.tableView.dataSource= self;
    self.tableView.delegate= self;
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self setupUI];
    self.displayGroup= kMyGroup;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title= self.navigationTitle;
}


-(void) setupUI {
    
    UIBarButtonItem *dropDown = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dropDown.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dropDown:)];
    dropDown.tintColor= [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem= dropDown;
}

-(void) dropDown:(UIBarButtonItem*) sender {
    
    sender.image= [UIImage imageNamed:@"dropDown-inv.png"];
    
    float height= 25.0;
    float width= 140.0;
    
    UIButton* createGroup= [UIButton buttonWithType:UIButtonTypeCustom];
    [createGroup setTitle:@"Create new group" forState:UIControlStateNormal];
    createGroup.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    createGroup.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [createGroup setFrame:CGRectMake(0.0, 0.0, width, height)];
    [createGroup.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [createGroup setBackgroundColor:[UIColor clearColor]];
    
    [createGroup setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        [self.popTipView dismissAnimated:NO];
        
        
        CreateGroupViewController* createGroupVC= [self.storyboard instantiateViewControllerWithIdentifier:@"CreateGroupVC"];
        createGroupVC.title= @"Create Group (step 1 of 2)";
        self.navigationItem.title= @"";
        self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
        [self.navigationController pushViewController:createGroupVC animated:YES];
    }];
    
    UIButton* groupsCreatedByMe= [UIButton buttonWithType:UIButtonTypeCustom];
    [groupsCreatedByMe setTitle:@"My Groups" forState:UIControlStateNormal];
    groupsCreatedByMe.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    groupsCreatedByMe.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [groupsCreatedByMe setFrame:CGRectMake(0.0, height, width, height)];
    [groupsCreatedByMe.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [groupsCreatedByMe setBackgroundColor:[UIColor clearColor]];
    
    [groupsCreatedByMe setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        [self.popTipView dismissAnimated:NO];
        self.displayGroup= kMyGroup;
        [self getGroups];
    }];
    
    UIButton* groupAdmined= [UIButton buttonWithType:UIButtonTypeCustom];
    [groupAdmined setTitle:@"Groups created by me" forState:UIControlStateNormal];
    groupAdmined.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    groupAdmined.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [groupAdmined setFrame:CGRectMake(0.0, height*2, width, height)];
    [groupAdmined.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [groupAdmined setBackgroundColor:[UIColor clearColor]];
    
    [groupAdmined setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        [self.popTipView dismissAnimated:NO];
        self.displayGroup= kAdminedGroup;
        [self getGroups];
    }];
    
    UIButton* publicGroups= [UIButton buttonWithType:UIButtonTypeCustom];
    [publicGroups setTitle:@"Public Groups" forState:UIControlStateNormal];
    publicGroups.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    publicGroups.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [publicGroups setFrame:CGRectMake(0.0, height*3, width, height)];
    [publicGroups.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [publicGroups setBackgroundColor:[UIColor clearColor]];
    
    [publicGroups setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        [self.popTipView dismissAnimated:NO];
        self.displayGroup= kPublicGroup;
        [self getGroups];
    }];
    
    UIView* contain= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height*4)];
    contain.backgroundColor= [UIColor clearColor];
    
    switch (self.displayGroup) {
        case kMyGroup:{
            [groupsCreatedByMe setEnabled:NO];
            [groupsCreatedByMe setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            break;
        case kPublicGroup: {
            [publicGroups setEnabled:NO];
            [publicGroups setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        }
            break;
        default: {
            [groupAdmined setEnabled:NO];
            [groupAdmined setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            break;
    }
    
    [contain addSubview:createGroup];
    [contain addSubview:groupsCreatedByMe];
    [contain addSubview:groupAdmined];
    [contain addSubview:publicGroups];
    
    self.popTipView= [[CMPopTipView alloc] initWithCustomView:contain];
    self.popTipView.backgroundColor= [UIColor darkGrayColor];
    self.popTipView.has3DStyle= NO;
    self.popTipView.hasShadow= NO;
    self.popTipView.dismissTapAnywhere= YES;
    self.popTipView.hasGradientBackground= NO;
    self.popTipView.delegate= self;
    [self.popTipView presentPointingAtBarButtonItem:sender animated:YES];
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // User can tap CMPopTipView to dismiss it
    self.navigationItem.rightBarButtonItem.image= [UIImage imageNamed:@"dropDown.png"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark API calls
-(void) getGroups {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken};
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    
    NSString* groupURL;
    switch (self.displayGroup) {
        case kMyGroup:
            groupURL= kGroupsUrl;
            break;
        case kPublicGroup:
            groupURL= kPublicGroupsUrl;
            break;
        case kAdminedGroup:
            groupURL= kAdminedGroupsUrl;
            break;
        default:
            break;
    }
    
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, groupURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        self.groups= [[NSMutableArray alloc] init];
        [self.tableView reloadData];
        for (id group in [[responseObject objectForKey:@"output"] objectForKey:@"response"]) {
            GroupInfo* groupInfo= [[GroupInfo alloc] initWithAttributes:group];
            [self.groups addObject:groupInfo];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Handle reachability here
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}


#pragma mark UITableView delegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    GroupInfo* groupData= [self.groups objectAtIndex:indexPath.row];
    [cell.imageEvent setImageWithURL:groupData.photoURL];
    
    [cell.imageDistance setHidden:YES];
    [cell.labelDistance setHidden:YES];
    
    cell.imageEvent.layer.cornerRadius= CGRectGetHeight(cell.imageEvent.frame)/2;
    cell.imageEvent.layer.masksToBounds = YES;
    cell.imageEvent.clipsToBounds= YES;
    cell.labelEventTitle.text= groupData.name;
    cell.labelEventDescription.text= groupData.groupDescription;
    cell.labelMembers.text= [NSString stringWithFormat:@"%lu%@", (unsigned long)groupData.countMembers, kMembersText];
    cell.labelDuration.text= [NSString stringWithFormat:@"%lu", (unsigned long)groupData.countPosts];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupDetailViewController* groupDetailVC= [self.storyboard instantiateViewControllerWithIdentifier:@"GroupDetailVC"];
    groupDetailVC.groupInfo= [self.groups objectAtIndex:indexPath.row];
    groupDetailVC.navigationItem.title= @"Group";
    self.navigationItem.title= @"";
    self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
    [self.navigationController pushViewController:groupDetailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
