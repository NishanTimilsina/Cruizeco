//
//  MyEventsViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/8/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "MyEventsViewController.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>


#import "EventInfo.h"
#import "EventTableViewCell.h"

@interface MyEventsViewController ()

@property (strong, nonatomic) NSDictionary* cachedResponse;
@property (strong, nonatomic) NSMutableArray* myEvents;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString* cellIdentifier = @"MyEventsTableViewCell";
static NSString* kMembersText= @"";

@implementation MyEventsViewController

-(NSMutableArray*) myEvents {
    if (!_myEvents) {
        _myEvents= [[NSMutableArray alloc] init];
    }
    return _myEvents;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken};
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    
//    [manager.requestSerializer setValue:self.servicePointId forHTTPHeaderField:@"PB_SERVICE_POINT_COUNTER_ID"];
//    [manager.requestSerializer setValue:self.restaurantId forHTTPHeaderField:@"PB_SERVICE_POINT_RESTAURANT_ID"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kMyEventsUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        
        for (id event in [[responseObject objectForKey:@"output"] objectForKey:@"response"]) {
            EventInfo* eventInfo= [[EventInfo alloc] init];
            [eventInfo initWithAttributes:event];
            [self.myEvents addObject:eventInfo];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Handle reachability here
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myEvents count];
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
//
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    EventTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    EventInfo* eventData= [self.myEvents objectAtIndex:indexPath.row];
    //problem loading[cell.imageEvent setImageWithURL:[eventData.photos objectAtIndex:0]];
    //by rabi
    [cell.imageEvent setImageWithURL:eventData.hostProfilePictureURL];
    cell.imageEvent.layer.cornerRadius= CGRectGetHeight(cell.imageEvent.frame)/2;
    cell.imageEvent.layer.masksToBounds = YES;
    cell.imageEvent.clipsToBounds=YES;
    cell.labelEventTitle.text= eventData.title;
    cell.labelEventDescription.text= eventData.eventDescription;
    cell.labelMembers.text= [NSString stringWithFormat:@"%lu%@", (unsigned long)eventData.countMembers, kMembersText];
    cell.labelDuration.text= [NSString stringWithFormat:@"%@", eventData.duration];
    cell.labelDistance.text= @"19km";//[NSString stringWithFormat:@"%@", eventData.duration];

    return cell;
}





@end
