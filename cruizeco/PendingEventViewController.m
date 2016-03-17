//
//  PendingEventViewController.m
//  cruizeco
//
//  Created by One Platinum on 1/27/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "PendingEventViewController.h"
#import "PendingEvent.h"
#import "PendingEventTableViewCell.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

@interface PendingEventViewController ()

@end

@implementation PendingEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma table view cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

@end
