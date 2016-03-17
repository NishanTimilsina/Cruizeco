//
//  MembersViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/9/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "MembersViewController.h"


#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>
#import "TSMessage.h"

#import "MyFriend.h"

#import "MemberTableViewCell.h"
#import "UIButton+Block.h"

#import "GroupDetailViewController.h"

@interface MembersViewController ()

/**
 
 Table view for member display
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 Text field where users will type for the members they want to search
 */
@property (weak, nonatomic) IBOutlet UITextField *textQuery;

/**
 Number of indexed characters
 */
@property NSInteger indexedNameCount;

/**
 The array of NSDictionary objects with indexed characters and count of objects in it
 */
@property (strong, nonatomic) NSMutableArray* indexedNames;

/**
 Number of network retries
 */
@property NSInteger networkRetries;

/**
 Friends matching current search conditions
 */
@property (strong, nonatomic) NSMutableArray* friends;

/**
 All results for friends. This array will remain unaffected for search and indices
 */
@property (strong, nonatomic) NSMutableArray* allFriends;

/**
 Array for names of selected friends
 */
@property (strong, nonatomic) NSMutableArray* names;

/**
 Array for names of all friends
 */
@property (strong, nonatomic) NSMutableArray* allNames;


/**
 Viewport to display all selected members
 */
@property (strong, nonatomic) UIView* viewSelectedMembers;

@property (strong, nonatomic) UILabel* noSelectionLabel;
@end

@implementation MembersViewController

-(UILabel*) noSelectionLabel {
    if (!_noSelectionLabel) {
        _noSelectionLabel= [[UILabel alloc] initWithFrame:CGRectMake(10.0, 15.0, 1.0, 20.0)];
        _noSelectionLabel.backgroundColor= [UIColor clearColor];
        _noSelectionLabel.text= @"Select members for the group";
        _noSelectionLabel.textColor= [UIColor darkGrayColor];
        _noSelectionLabel.font= [UIFont fontWithName:@"Helvetica" size:11.0];
        [_noSelectionLabel sizeToFit];
        
    }
    return _noSelectionLabel;
}

-(UIView*) viewSelectedMembers {
    if (!_viewSelectedMembers) {
        CGRect frame= CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 50.0);
        _viewSelectedMembers= [[UIView alloc] initWithFrame:frame];
        _viewSelectedMembers.backgroundColor= [UIColor clearColor];
        [_viewSelectedMembers addSubview:self.noSelectionLabel];
    }
    return _viewSelectedMembers;
}

-(void) refreshSelectedMembersView {
    BOOL itemsPreviouslyExist= NO;
    for (UIView* object in self.viewSelectedMembers.subviews) {
        if([object isKindOfClass:[UIButton class]]) {
            itemsPreviouslyExist= YES;
            [object removeFromSuperview];
        }
    }
    if (!itemsPreviouslyExist) {
        [self.viewSelectedMembers addSubview:self.noSelectionLabel];
    }
    NSInteger indexCounter= 0;
    for (MyFriend* myFriend in self.friends) {
        if (myFriend.isSelected) {
            [self addNameToSelected:myFriend.friendName atIndex:indexCounter];
        }
        indexCounter++;
    }
}

-(void) addNameToSelected:(NSString*) name atIndex:(NSInteger) index {
    [self.noSelectionLabel removeFromSuperview];
    
    UIButton* nameButon= [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButon setTitle:[NSString stringWithFormat:@"  %@ X  ", name] forState:UIControlStateNormal];
    [nameButon setTitleColor:[self defaultColor] forState:UIControlStateNormal];
    nameButon.titleLabel.font= [UIFont fontWithName:@"Helvetica" size:11.0];
    [nameButon sizeToFit];
    nameButon.layer.cornerRadius= CGRectGetHeight(nameButon.frame)/2.0;
    nameButon.layer.masksToBounds= YES;
    nameButon.layer.borderWidth= 1.0;
    nameButon.layer.borderColor= [self defaultColor].CGColor;
    nameButon.tag= index;
    
    [nameButon setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        MyFriend* myFriend= [self.friends objectAtIndex:index];
        myFriend.isSelected= NO;
        [self.tableView reloadData];
        [self refreshSelectedMembersView];
    }];
    
    [nameButon setBackgroundColor:[UIColor clearColor]];
    
    CGRect frame= CGRectZero;
    float paddingY= 5.0;
    float paddingX= 8.0;
    
    for (UIButton* button in self.viewSelectedMembers.subviews) {
        frame= button.frame;
    }
    CGRect proposedFrame= CGRectMake(frame.origin.x + frame.size.width, frame.origin.y, nameButon.frame.size.width, nameButon.frame.size.height);
    if (proposedFrame.origin.x + proposedFrame.size.width > (self.viewSelectedMembers.frame.size.width-paddingX)) {
        proposedFrame.origin.y+= proposedFrame.size.height +paddingY;
        proposedFrame.origin.x= 0.0;
    }
    proposedFrame.origin.x+= paddingX;
    if (proposedFrame.origin.y == 0) {
        proposedFrame.origin.y= paddingY;
    }
    [nameButon setFrame:proposedFrame];
    [self.viewSelectedMembers addSubview:nameButon];
    CGRect selectedMembersFrame= self.viewSelectedMembers.frame;
    selectedMembersFrame.size.height= proposedFrame.origin.y+ proposedFrame.size.height+ paddingY;
    if (selectedMembersFrame.size.height < 50) {
        selectedMembersFrame.size.height= 50;
    }
    [self.viewSelectedMembers setFrame:selectedMembersFrame];
    self.tableView.tableHeaderView= self.viewSelectedMembers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView layoutIfNeeded];
    self.tableView.dataSource= self;
    self.tableView.delegate= self;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.tableView.allowsMultipleSelection= YES;
    self.textQuery.delegate= self;
    //    self.textQuery.backgroundColor= self.navigationController.navigationBar.tintColor;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setupUI];
    [self getFriends];
}

-(void) setupUI {
    
    NSMutableArray* navArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [navArray removeObjectAtIndex:[navArray count]-2];
    [self.navigationController setViewControllers:navArray animated:NO];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:NO];
    
    
    self.tableView.tableHeaderView= self.viewSelectedMembers;
    self.tableView.tableFooterView= [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    
    UIBarButtonItem *dropDown = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"check_nav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addMembersToGroup)];
    dropDown.tintColor= [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem= dropDown;
}

-(void) viewDidAppear:(BOOL)animated {
//    [self.textQuery layoutIfNeeded];
//    CALayer *bottomBorder = [CALayer layer];
//    bottomBorder.frame = CGRectMake(0.0f, self.textQuery.frame.size.height - 1, self.textQuery.frame.size.width, 1.0f);
//    bottomBorder.backgroundColor = [self defaultColor].CGColor;
//    [self.textQuery.layer addSublayer:bottomBorder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark API calls
-(void) getFriends
{
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken};
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kMyFriendList] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            if (self.networkRetries < 3) {
                self.networkRetries++;
                [self getFriends];
            }
            return;
        }
        self.networkRetries= 0;
        self.friends= [[NSMutableArray alloc] init];
        self.allFriends= [[NSMutableArray alloc] init];
        self.indexedNames= [[NSMutableArray alloc] init];
        self.names= [[NSMutableArray alloc] init];
        self.allNames= [[NSMutableArray alloc] init];
        for (NSDictionary* myFriend in [[responseObject objectForKey:@"output"] objectForKey:@"response"]) {
            MyFriend* friend= [[MyFriend alloc] initWithAttributes:myFriend];
            [self.allNames addObject:friend.friendName];
            [self createIndex:friend];
        }
        self.allFriends= self.friends;
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.networkRetries < 3) {
            self.networkRetries++;
            [self getFriends];
            return;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


-(void) addMembersToGroup
{
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSMutableArray* userIds= [[NSMutableArray alloc] init];
    for (MyFriend* myFriend in self.friends) {
        if (myFriend.isSelected) {
            [userIds addObject:myFriend.friendID];
        }
    }
    
    NSDictionary *params = @{
        @"token": kStaticToken,
        @"group_id": self.groupId,
        @"user": userIds
    };
    
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kAddUsersToGroup] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            if (self.networkRetries < 3) {
                self.networkRetries++;
                [self addMembersToGroup];
            }
            return;
        }
        self.networkRetries= 0;
        GroupDetailViewController* groupDetailVC= [self.storyboard instantiateViewControllerWithIdentifier:@"GroupDetailVC"];
        groupDetailVC.groupId= self.groupId;
        groupDetailVC.removePreviousViewFromNavigationStack= YES;
        groupDetailVC.title= @"Group";
        self.navigationController.title= @"";
        [self.navigationController pushViewController:groupDetailVC animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.networkRetries < 3) {
            self.networkRetries++;
            [self getFriends];
            return;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexedNameCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.indexedNames objectAtIndex:section] objectForKey:@"row"] integerValue];
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel* character= [[UILabel alloc] initWithFrame:CGRectMake(35.0, 5.0, 25.0, 25.0)];
    character.font= [UIFont fontWithName:@"Helevetica" size:9.0];
    character.textColor= [UIColor whiteColor];
    character.textAlignment= NSTextAlignmentCenter;
    character.backgroundColor= [self secondDefaultColor];
    character.text= [[self.indexedNames objectAtIndex:section] objectForKey:@"character"];
    character.layer.cornerRadius= CGRectGetHeight(character.frame)/2.0;
    character.layer.masksToBounds= YES;
    
    [headerView addSubview:character];
    return headerView;
}

#pragma mark UITableViewScrollIndex
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray* indices= [[NSMutableArray alloc] init];
    for (NSDictionary* object in self.indexedNames) {
        [indices addObject:[object objectForKey:@"character"]];
    }
    return indices;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark UITableView cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"MemberTVC" forIndexPath:indexPath];
    
    if (!cell) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberTVC"];
    }
    
    
    NSInteger previousRows= 0;
    for (int i= 0; i < indexPath.section; i++) {
        previousRows += [self.tableView numberOfRowsInSection:i];
    }
    
    MyFriend* myFriend= [self.friends objectAtIndex:indexPath.row+previousRows];
    
    [cell.ivMemberPhoto setImageWithURL:myFriend.friendPhoto];
    [cell layoutIfNeeded];
    
    cell.ivMemberPhoto.layer.cornerRadius= CGRectGetHeight(cell.ivMemberPhoto.frame)/2.0;
    cell.ivMemberPhoto.layer.masksToBounds= YES;
    
    cell.labelMemberName.text= myFriend.friendName;
    for (UIView* sub in cell.viewTags.subviews) {
        [sub removeFromSuperview];
    }
    [cell.viewTags addSubview:myFriend.viewForTags];
    cell.viewTags.frame= CGRectMake(cell.viewTags.frame.origin.x, cell.viewTags.frame.origin.y, myFriend.viewForTags.frame.size.width, myFriend.viewForTags.frame.size.height);
    cell.accessoryView.hidden= YES;
    cell.accessoryType= UITableViewCellAccessoryNone;
    
    if (myFriend.isSelected) {
        cell.accessoryView.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.names addObject:myFriend.friendName];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger previousRows= 0;
    for (int i= 0; i < indexPath.section; i++) {
        previousRows += [self.tableView numberOfRowsInSection:i];
    }
    
    MyFriend* myFriend= [self.friends objectAtIndex:indexPath.row+previousRows];
    return 70.0 + myFriend.viewForTags.frame.size.height;
}

#pragma mark UITableViewCellSelection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger previousRows= 0;
    for (int i= 0; i < indexPath.section; i++) {
        previousRows += [self.tableView numberOfRowsInSection:i];
    }
    self.names= [[NSMutableArray alloc] init];
    MyFriend* myFriend= [self.friends objectAtIndex:indexPath.row+previousRows];
    if (myFriend.isSelected) {
        [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
        return;
    }
    myFriend.isSelected= YES;
    [tableView reloadData];
    [self refreshSelectedMembersView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger previousRows= 0;
    for (int i= 0; i < indexPath.section; i++) {
        previousRows += [self.tableView numberOfRowsInSection:i];
    }
    self.names= [[NSMutableArray alloc] init];
    MyFriend* myFriend= [self.friends objectAtIndex:indexPath.row+previousRows];
    myFriend.isSelected= NO;
    [self.tableView reloadData];
    [self refreshSelectedMembersView];
}

#pragma mark Search
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([textField isEqual:self.textQuery]) {
        if (range.location == 0 && range.length == 1) {
            [self searchFriends:string];
        } else {
            [self searchFriends:[NSString stringWithFormat:@"%@%@", textField.text, string]];
        }
    }
    return YES;
}

-(void) searchFriends:(NSString*) matchAgainst
{
    [self resetIndex];
    for (MyFriend* friend in self.allFriends) {
        if (matchAgainst && matchAgainst.length) {
            if ([[friend.friendName lowercaseString] rangeOfString:[matchAgainst lowercaseString]].location != NSNotFound) {
                [self createIndex:friend];
            }
        } else {
            [self createIndex:friend];
        }
    }
    [self.tableView reloadData];
}


#pragma mark Indexing
-(void) resetIndex
{
    self.indexedNameCount= 0;
    self.indexedNames= [[NSMutableArray alloc] init];
    self.friends= [[NSMutableArray alloc] init];
}

-(void) createIndex:(MyFriend*) friend
{
    [self.friends addObject:friend];
    BOOL contains= NO;
    for (NSMutableDictionary* indexedNameDef in self.indexedNames) {
        if ([[indexedNameDef objectForKey:@"character"] isEqual:[friend.friendName substringToIndex:1]]) {
            contains= YES;
            NSString* rows= [NSString stringWithFormat:@"%d", ([[indexedNameDef objectForKey:@"row"] intValue] + 1)];
            [indexedNameDef setObject:rows forKey:@"row"];
        }
    }
    if (!contains) {
        self.indexedNameCount++;
        NSMutableArray* keys= [NSMutableArray arrayWithObjects:@"row", @"character", nil];
        NSMutableArray* objects= [NSMutableArray arrayWithObjects:@"1", [[friend.friendName substringToIndex:1] uppercaseString], nil];
        [self.indexedNames addObject:[NSMutableDictionary dictionaryWithObjects:objects forKeys:keys]];
    }
    
}

@end
