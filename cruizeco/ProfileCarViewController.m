//
//  ProfileCarViewController.m
//  cruizeco
//
//  Created by One Platinum on 1/14/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "ProfileCarViewController.h"
#import "Profile.h"
#import "ProfileCarsCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CarInfo.h"
#import "AddCarsViewController.h"
#import "InviteViewController.h"
#import "PendingViewController.h"
@interface ProfileCarViewController ()

@property (strong, nonatomic) NSMutableArray* carImages;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addMoreCars;
@property (strong, nonatomic) IBOutlet UIView * testView;
//@property(strong,nonatomic)NSString*test;
@end

@implementation ProfileCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource= self;
    self.collectionView.delegate= self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileIsAvailable:) name:@"profileCarAvailable" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*byrabi*/
- (IBAction)addMoreCars:(id)sender {
    AddCarsViewController*addcarsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarsVC"];
    [self.navigationController pushViewController:addcarsVC animated:YES];
}
- (IBAction)inviteButton:(id)sender {
    InviteViewController*addcarsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteVC"];
    [self.navigationController pushViewController:addcarsVC animated:YES];
}
- (IBAction)pendingButton:(id)sender {
    PendingViewController*addcarsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PendingVC"];
    [self.navigationController pushViewController:addcarsVC animated:YES];
}

/*ends here*/

-(void) profileIsAvailable:(NSNotification*)notification
{
    //self.test=[NSString stringWithFormat:@"%ld",((Profile*)notification.userInfo).carCount];
    //NSString* tempString = [NSString stringWithFormat:@"%@", self.test];
   // NSLog(@"this is test%@",self.test);
    self.carImages= ((Profile*)notification.userInfo).cars;
    [self.collectionView reloadData];
}

//pragma marks collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.carImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //ProfileCarsCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCarsCVC" forIndexPath:indexPath];
    ProfileCarsCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCarsCVC" forIndexPath:indexPath];
    NSURL* imageURL= [((CarInfo*)[self.carImages objectAtIndex:indexPath.row]).images objectAtIndex:indexPath.row];
    [cell.ivCarsImages setImageWithURL:imageURL];
    return cell;
}

@end
