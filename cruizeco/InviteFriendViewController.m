//
//  InviteFriendViewController.m
//  cruizeco
//
//  Created by One Platinum on 1/25/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "InviteFriendTableViewCell.h"
#import "Friend.h"
#import "Invite.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
//By rabi
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

@interface InviteFriendViewController ()
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (strong,nonatomic)NSMutableArray*inviteFriendinfo;

@end
static NSString* cellIdentifier = @"InviteFriendTVC";

@implementation InviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendTableView.dataSource = self;
    self.friendTableView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inviteFriendIsAvailable:) name:@"inviteFriendAvailable" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)inviteFriendIsAvailable:(NSNotification*)notification{
    self.inviteFriendinfo = ((Invite*)notification.userInfo).friends;
    NSLog(@"invitefriends%@",self.inviteFriendinfo);
    [self.friendTableView reloadData];
}
- (IBAction)btnInviteAccept:(UIButton*)sender {
    Friend* friendData = [self.inviteFriendinfo objectAtIndex:sender.tag];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"token": kStaticToken,
                             @"friend": friendData.friendId,
                             @"status":@"1"
                             };
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, krespondRequest] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.inviteFriendinfo removeObjectAtIndex:0];
        [self.friendTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)btnInvitePending:(UIButton*)sender {
    Friend* friendData = [self.inviteFriendinfo objectAtIndex:sender.tag];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"token": kStaticToken,
                             @"friend": friendData.friendId,
                             @"status":@"2"
                             };
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, krespondRequest] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.inviteFriendinfo removeObjectAtIndex:0];
        [self.friendTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//pragma marks table view cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.inviteFriendinfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InviteFriendTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =[[InviteFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    Friend* friendData= [self.inviteFriendinfo objectAtIndex:indexPath.row];
    [cell.friendPhoto setImageWithURL:friendData.photo];
    cell.friendPhoto.layer.cornerRadius= CGRectGetHeight(cell.friendPhoto.frame)/3.5;
    cell.friendPhoto.layer.masksToBounds = YES;
    cell.friendPhoto.clipsToBounds=YES;
    cell.friendName.text=friendData.invitedBy;
    cell.requestWithName.text=[friendData.invitedBy stringByAppendingString:@" has send you friend request"];
    cell.btnAccept.tag = indexPath.row;
    cell.btnReject.tag = indexPath.row;
    
    return cell;
}


@end
