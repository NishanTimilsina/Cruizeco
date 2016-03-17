//
//  PendingFriendViewController.m
//  cruizeco
//
//  Created by One Platinum on 1/25/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "PendingFriendViewController.h"
#import "PendingFriendTableViewCell.h"
#import "Pending.h"
#import "PendingFriend.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
//By rabi
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>
@interface PendingFriendViewController ()
@property (weak, nonatomic) IBOutlet UITableView *pendingTableView;
@property (strong,nonatomic)NSMutableArray* pendingFriendInfo;
@end
static NSString * cellIdentifier = @"PendingFriendTVC";

@implementation PendingFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pendingTableView.dataSource = self;
    self.pendingTableView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pendingFriendIsAvailable:) name:@"pendingFriendAvailable" object:nil];
}

- (void)didReceiveMemoryWarning {
    //[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pendingFriendIsAvailable:(NSNotification*)notification
{
    self.pendingFriendInfo= ((Pending*)notification.userInfo).friends;
   // NSLog(@"profileTest%@",self.pendingFriendInfo);
    [self.pendingTableView reloadData];
}
- (IBAction)btnCancel:(UIButton*)sender {
    PendingFriend* friendData= [self.pendingFriendInfo objectAtIndex:sender.tag];
   // NSLog(@"testheloo%@",friendData);
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"token": kStaticToken,
                             @"friend": friendData.friendId
                             };
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kcancelRequest] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.pendingFriendInfo removeObjectAtIndex:0];
        [self.pendingTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma marks table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pendingFriendInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PendingFriendTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[PendingFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    PendingFriend* friendData = [self.pendingFriendInfo objectAtIndex:indexPath.row];
    [cell.pendingImage setImageWithURL:friendData.friendPhoto];
    [cell.contentView.superview setClipsToBounds:NO];
    cell.pendingImage.layer.cornerRadius= CGRectGetHeight(cell.pendingImage.frame)/4.5;
    cell.pendingImage.layer.masksToBounds = YES;
    cell.pendingImage.clipsToBounds=YES;
    cell.btnPendingCancel.tag= indexPath.row;
    cell.pendingName.text = friendData.friendName;
    
    return cell;
}

@end
