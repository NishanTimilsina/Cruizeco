//
//  ProfileViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/6/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "ProfileViewController.h"

#import "PKRevealController.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
//By rabi
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>
#import "InviteViewController.h"
#import "PendingViewController.h"



@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnCars;
@property (weak, nonatomic) IBOutlet UIView *ContentCars;
@property (weak, nonatomic) IBOutlet UIView *contentInterest;
@property (weak, nonatomic) IBOutlet UIView *contentLocation;


@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *InviteCount;
@property (weak, nonatomic) IBOutlet UILabel *PendingCount;
@property(weak,nonatomic) NSDictionary *PlaceItem;

@property (weak, nonatomic) IBOutlet UILabel *ProfileName;
@property (weak, nonatomic) IBOutlet UIView *testview;







@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCars];
    //18 168 171
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"add-more-below-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 53, 31)];
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 50, 20)];
    //    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
    //    [label setText:title];
    //    label.textAlignment = UITextAlignmentCenter;
    //    [label setTextColor:[UIColor whiteColor]];
    //    [label setBackgroundColor:[UIColor clearColor]];
    //    [button addSubview:label];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.navigationItem.leftBarButtonItem = barButton;
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
    self.ProfileName.textAlignment = NSTextAlignmentCenter;
    self.ProfileName.textColor = [UIColor whiteColor];
    
    self.ProfileImage.layer.cornerRadius=62;
    //self.ProfileImage.layer.borderWidth=5.0;
    self.ProfileImage.layer.masksToBounds = YES;
   // self.ProfileImage.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    //self.ProfileImage.layer.borderColor =[UIColor colorWithRed:(35/255.0) green:(164/255.0) blue:(166/255.0) alpha:1].CGColor;    //CGRect frame = CGRectMake(105, 110, 10, 180);
    //self.ProfileName.frame = frame;
    //self.ProfileImage.frame = frame;
   // self.ProfileImage.frame = [[UIColor redColor]CGColor];
    //CGFloat borderWidth = 1.0f;
    
    //self.ProfileImage.frame = CGRectInset(self.ProfileImage.frame, borderWidth, borderWidth);
    //self.ProfileImage.layer.borderColor = [UIColor yellowColor].CGColor;
    //self.ProfileImage.layer.borderWidth = borderWidth;
    

//#define kCornerRadius 8.0
   // #define kBoarderWidth 3.0
    NSInteger width = 1;
    NSInteger radius = 66;
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(43, 18,127, 132);
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:radius];
   [borderLayer setBorderWidth:width];
    [borderLayer setBorderColor:[UIColor colorWithRed:(35/255.0) green:(164/255.0) blue:(166/255.0) alpha:1].CGColor];
    [self.testview.layer addSublayer:borderLayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnInvite:(UIButton*)sender {
    InviteViewController*inviteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteVC"];
    [self.navigationController pushViewController:inviteVC animated:YES];
}
- (IBAction)btnPending:(id)sender {
    PendingViewController*pendingVC =[self.storyboard instantiateViewControllerWithIdentifier:@"PendingVC"];
    [self.navigationController pushViewController:pendingVC animated:YES];
}
- (IBAction)btnCars:(id)sender {
    self.ContentCars.alpha = 1;
    self.contentInterest.alpha = 0;
    self.contentLocation.alpha = 0;
}
- (IBAction)btnInterest:(id)sender {
    self.ContentCars.alpha = 0;
    self.contentInterest.alpha = 1;
    self.contentLocation.alpha = 0;
}
- (IBAction)btnLocation:(id)sender {
    self.ContentCars.alpha = 0;
    self.contentInterest.alpha = 0;
    self.contentLocation.alpha = 1;
}
-(void)setupUI{
    self.ProfileName.text = self.profileInfo.me;
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
    //[self.ProfileImage setImageWithURL:self.profileInfo.myPhoto set:""];
    [self.ProfileImage setImageWithURL:self.profileInfo.myPhoto];
    //self.ProfileImage setImageWithURL = self.profileInfo.myPhoto;
    //self.ProfileImage.image = self.profileInfo.myPhoto;
    NSNumber *inviteCount = @(self.profileInfo.inviteCount);
    NSString *finalInvite = [inviteCount stringValue];
    self.InviteCount.text = finalInvite;
    
    NSNumber *pendingcount = @(self.profileInfo.requestPendingCount);
    NSString *finalpendingcount = [pendingcount stringValue];
    self.PendingCount.text = finalpendingcount;
}

#pragma mark API Calls
-(void)getCars{
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken};
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@",kBaseUrl,kProfile] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"test%@",responseObject);
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        
        //self.hello = self.profiles;
        self.profileInfo = [[Profile alloc]initWithAttribute:[[responseObject objectForKey:@"output"] objectForKey:@"response"]];
        [self setupUI];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"profileCarAvailable" object:self userInfo:self.profileInfo];
        
        NSNotificationCenter* ncInterest = [NSNotificationCenter defaultCenter];
        [ncInterest postNotificationName:@"profileInterestAvailable" object:self userInfo:self.profileInfo];
        
        NSNotificationCenter* ncLocation = [NSNotificationCenter defaultCenter];
        [ncLocation postNotificationName:@"profileLocationAvailable" object:self userInfo:self.profileInfo];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
  
    
   
}
#pragma mark - PKRevealing

- (void)revealController:(PKRevealController *)revealController didChangeToState:(PKRevealControllerState)state
{
    NSLog(@"%@ (%d)", NSStringFromSelector(_cmd), (int)state);
}

- (void)revealController:(PKRevealController *)revealController willChangeToState:(PKRevealControllerState)next
{
    PKRevealControllerState current = revealController.state;
    NSLog(@"%@ (%d -> %d)", NSStringFromSelector(_cmd), (int)current, (int)next);
}

@end
