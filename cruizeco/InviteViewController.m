//
//  InviteViewController.m
//  cruizeco
//
//  Created by One Platinum on 1/20/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "InviteViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

@interface InviteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnfriend;
@property (weak, nonatomic) IBOutlet UIButton *btnGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnEvent;
@property (weak, nonatomic) IBOutlet UIView *friendContainer;
@property (weak, nonatomic) IBOutlet UIView *groupContainer;
@property (weak, nonatomic) IBOutlet UIView *eventContainer;
@property (weak, nonatomic) IBOutlet UILabel *labelFriend;
@property (weak, nonatomic) IBOutlet UILabel *labelGroup;
@property (weak, nonatomic) IBOutlet UILabel *labelEvent;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getInviteLists];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnFriend:(id)sender {
    self.friendContainer.alpha = 1;
    self.groupContainer.alpha = 0;
    self.eventContainer.alpha = 0;
    self.labelFriend.textColor = [UIColor colorWithRed:(15/255.0) green:(168/255.0) blue:(171/255.0) alpha:1.0];
    self.labelGroup.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    self.labelEvent.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
}
- (IBAction)btnGroup:(id)sender {
    self.friendContainer.alpha = 0;
    self.groupContainer.alpha = 1;
    self.eventContainer.alpha = 0;
    self.labelGroup.textColor = [UIColor colorWithRed:(15/255.0) green:(168/255.0) blue:(171/255.0) alpha:1.0];
    self.labelFriend.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    self.labelEvent.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
}
- (IBAction)btnEvent:(id)sender {
    self.friendContainer.alpha = 0;
    self.groupContainer.alpha = 0;
    self.eventContainer.alpha = 1;
    self.labelEvent.textColor = [UIColor colorWithRed:(15/255.0) green:(168/255.0) blue:(171/255.0) alpha:1.0];
    self.labelFriend.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    self.labelGroup.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
}


#pragma mark API Calls
-(void)getInviteLists{
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken};
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@",kBaseUrl,kinviteList] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"test%@",responseObject);
       self.inviteInfo = [[Invite alloc]initWithAttributes:[[[responseObject objectForKey:@"output"]objectForKey:@"response"]objectForKey:@"invitations"]];
        
        
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"inviteFriendAvailable" object:self userInfo:self.inviteInfo];
        
        NSNotificationCenter* ncGroup = [NSNotificationCenter defaultCenter];
        [ncGroup postNotificationName:@"inviteGroupAvailable" object:self userInfo:self.inviteInfo];
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    
    
}


@end
