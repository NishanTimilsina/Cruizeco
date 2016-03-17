//
//  InviteGroupViewController.m
//  cruizeco
//
//  Created by One Platinum on 1/28/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "InviteGroupViewController.h"
#import "InviteGroupTableViewCell.h"
#import "Group.h"
#import "Invite.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
//By rabi
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

@interface InviteGroupViewController ()
@property (weak, nonatomic) IBOutlet UITableView *inviteGroupTableView;
@property(strong,nonatomic)NSMutableArray* inviteGroupInfo;
@end
static NSString* cellIdentifier = @"InviteGroupTVC";
@implementation InviteGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inviteGroupTableView.dataSource = self;
    self.inviteGroupTableView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inviteGroupIsAvailable:) name:@"inviteGroupAvailable" object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//nsnofication getting data from inviteViewcontroller
-(void)inviteGroupIsAvailable:(NSNotification*)notification{
    self.inviteGroupInfo = ((Invite*)notification.userInfo).groups;
    [self.inviteGroupTableView reloadData];
}
- (IBAction)btnAccept:(UIButton*)sender {
    Group* groupData = [self.inviteGroupInfo objectAtIndex:sender.tag];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"token": kStaticToken,
                             @"group_id": groupData.groupId,
                             @"status":@"1"
                             };
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, krespondRequest] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.inviteGroupInfo removeObjectAtIndex:0];
        [self.inviteGroupTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
- (IBAction)btnReject:(UIButton*)sender {
    Group* groupData = [self.inviteGroupInfo objectAtIndex:sender.tag];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"token": kStaticToken,
                             @"group_id": groupData.groupId,
                             @"status":@"2"
                             };
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, krespondRequest] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.inviteGroupInfo removeObjectAtIndex:0];
        [self.inviteGroupTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma marks table View Cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.inviteGroupInfo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InviteGroupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[InviteGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    Group* groupData = [self.inviteGroupInfo objectAtIndex:indexPath.row];
    [cell.photo setImageWithURL:groupData.groupPhoto];
    cell.photo.layer.cornerRadius= CGRectGetHeight(cell.photo.frame)/4.5;
    cell.photo.layer.masksToBounds = YES;
    cell.photo.clipsToBounds=YES;
    cell.name.text = groupData.invitedBy;
    NSString* groupText = @"has invited you to join";
    cell.userWithGroup.text = [NSString stringWithFormat:@"%@ %@ %@",groupData.invitedBy,groupText,groupData.groupName];
    cell.btnAccept.tag = indexPath.row;
    cell.btnReject.tag=indexPath.row;
    return cell;
}

@end
