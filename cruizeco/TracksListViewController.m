//
//  TracksListViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 8/19/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "TracksListViewController.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

#import "TrackInfo.h"
#import "TrackListTableViewCell.h"

#import "TrackDetailViewController.h"

#import <CMPopTipView.h>

#import "UIButton+Block.h"

#import "AddTrackViewController.h"

@interface TracksListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* tracks;


@property (strong, nonatomic) CMPopTipView* popTipView;
@end

@implementation TracksListViewController


-(NSMutableArray*) tracks {
    if (!_tracks) {
        _tracks= [[NSMutableArray alloc] init];
    }
    return _tracks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource= self;
    self.tableView.delegate= self;
    //    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self setupUI];
}

-(void) setupUI {
    
    UIBarButtonItem *dropDown = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dropDown.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dropDown:)];
    dropDown.tintColor= [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem= dropDown;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tracks= [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    [self getData];
    self.navigationItem.title= @"Routes";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void) dropDown:(UIBarButtonItem*) sender {
    
    sender.image= [UIImage imageNamed:@"dropDown-inv.png"];
    
    
    UIButton* addTrack= [UIButton buttonWithType:UIButtonTypeCustom];
    [addTrack setTitle:@"New Route" forState:UIControlStateNormal];
    [addTrack setFrame:CGRectMake(0.0, 0.0, 80.0, 25.0)];
    [addTrack.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [addTrack setBackgroundColor:[UIColor clearColor]];
    
    [addTrack setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        [self.popTipView dismissAnimated:NO];
        AddTrackViewController* addTrackVC= [self.storyboard instantiateViewControllerWithIdentifier:@"AddTrackVC"];
        addTrackVC.title= @"Add Route";
        self.navigationItem.title= @"";
        self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
        [self.navigationController pushViewController:addTrackVC animated:YES];
    }];
    
    UIView* contain= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 81.0, 26.0)];
    contain.backgroundColor= [UIColor clearColor];
    
    [contain addSubview:addTrack];
    
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

-(void) getData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken};
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    
    //    [manager.requestSerializer setValue:self.servicePointId forHTTPHeaderField:@"PB_SERVICE_POINT_COUNTER_ID"];
    //    [manager.requestSerializer setValue:self.restaurantId forHTTPHeaderField:@"PB_SERVICE_POINT_RESTAURANT_ID"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kMyTrackList] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        
        for (id track in [[[responseObject objectForKey:@"output"] objectForKey:@"response"] objectForKey:@"tracks"]) {
            TrackInfo* trackInfo= [[TrackInfo alloc] initWithAttributes:track];
            [self.tracks addObject:trackInfo];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Handle reachability here
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackListTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"TracksListTVC" forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[TrackListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TracksListTVC"];
    }
    TrackInfo* trackInfo= [self.tracks objectAtIndex:indexPath.row];
    cell.labelTrackTitle.text= trackInfo.title;
    cell.labelDuration.text= trackInfo.duration;
    cell.labelDistance.text= trackInfo.distance;
    
    cell.starBox.starImage= [UIImage imageNamed:@"white-star.png"];
    cell.starBox.starHighlightedImage= [UIImage imageNamed:@"gold-star.png"];
    cell.starBox.maxRating= 5.0;
    cell.starBox.delegate = self;
    cell.starBox.horizontalMargin = 12;
    cell.starBox.editable=YES;
    cell.starBox.displayMode=EDStarRatingDisplayFull;
    cell.starBox.rating= [trackInfo.rating floatValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrackDetailViewController* trackDetailVC= [self.storyboard instantiateViewControllerWithIdentifier:@"TrackDetailVC"];
    trackDetailVC.trackInfo= [self.tracks objectAtIndex:indexPath.row];
    trackDetailVC.navigationItem.title= @"Route";
    self.navigationItem.title= @"";
    self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
    [self.navigationController pushViewController:trackDetailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
