//
//  PendingGroupViewController.m
//  cruizeco
//
//  Created by One Platinum on 1/27/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "PendingGroupViewController.h"
#import "PendingGroupsTableViewCell.h"
#import "PendingGroup.h"
#import "Pending.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
//By rabi
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

@interface PendingGroupViewController ()
@property (weak, nonatomic) IBOutlet UITableView *pendingGroupTableView;


@property(strong,nonatomic)NSMutableArray* pendingGroupInfo;
@end
static NSString* cellIdentifier = @"PendingGroupsTVC";

@implementation PendingGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pendingGroupTableView.dataSource = self;
    self.pendingGroupTableView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pendingGroupIsAvailable:) name:@"pendingGroupAvailable" object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pendingGroupIsAvailable:(NSNotification*)notification{
    self.pendingGroupInfo = ((Pending*)notification.userInfo).groups;
    [self.pendingGroupTableView reloadData];
}
- (IBAction)acceptPendingGroup:(UIButton*)sender {
    PendingGroup* groupsData = [self.pendingGroupInfo objectAtIndex:sender.tag];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"token": kStaticToken,
                             @"group_id": groupsData.groupId,
                             @"user_id":groupsData.inviteeId,
                             @"status":@"1"
                             };
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kapprovegrouprequest] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.pendingGroupInfo removeObjectAtIndex:0];
        [self.pendingGroupTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)rejectPendingGroup:(UIButton*)sender {
    
    
    /*NSMutableArray* keys= [NSMutableArray arrayWithObjects:@"token", nil];
    NSMutableArray* objects= [NSMutableArray arrayWithObjects:kStaticToken, nil];
    
    NSMutableDictionary* params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
     [params setObject:@"test" forKey:@"cancelOrReject"];*/

    if ([sender.titleLabel.text isEqualToString:@"Cancel"]) {
        PendingGroup* groupsData = [self.pendingGroupInfo objectAtIndex:sender.tag];
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *params = @{
                                        @"token": kStaticToken,
                                        @"group_id": groupsData.groupId,
                                        @"user":groupsData.inviteeId,
                                        };
        [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
        [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kcancelRequest] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.pendingGroupInfo removeObjectAtIndex:0];
            [self.pendingGroupTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } else {
        PendingGroup* groupsData = [self.pendingGroupInfo objectAtIndex:sender.tag];
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *params = @{
                                        @"token": kStaticToken,
                                        @"group_id": groupsData.groupId,
                                        @"user_id":groupsData.inviteeId,
                                        @"status":@"2"
                                        };
        [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
        [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kapprovegrouprequest] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.pendingGroupInfo removeObjectAtIndex:0];
            [self.pendingGroupTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}


#pragma marks table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.pendingGroupInfo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PendingGroupsTableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[PendingGroupsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    PendingGroup* groupsData = [self.pendingGroupInfo objectAtIndex:indexPath.row];
    [cell.photo setImageWithURL:groupsData.groupPhoto];
    cell.photo.layer.cornerRadius= CGRectGetHeight(cell.photo.frame)/4.5;
    cell.photo.layer.masksToBounds = YES;
    cell.photo.clipsToBounds=YES;
    cell.name.text = groupsData.groupName;
    //NSString* userText = @"has not join group";
    //cell.userName.text = [NSString stringWithFormat:@"%@ %@",groupsData.invitee,userText];
    cell.userName.text =groupsData.message;
    cell.btnAccept.tag = indexPath.row;
    cell.btnReject.tag = indexPath.row;
    if ([groupsData.request integerValue] == 0) {
        cell.btnAccept.hidden  = YES;
        [cell.btnReject setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    return cell;
}

@end
