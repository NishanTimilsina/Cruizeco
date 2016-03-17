//
//  ProfileInterestsViewController.m
//  cruizeco
//
//  Created by One Platinum on 2/3/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "ProfileInterestsViewController.h"
#import "Profile.h"
#import "ProfileInterestInfo.h"

@interface ProfileInterestsViewController ()
@property (weak, nonatomic) IBOutlet UIView *interestTagView;
@property (weak, nonatomic) IBOutlet UIView *notInterestTagView;
@property (strong,nonatomic) NSMutableArray* interestInfo;
@end

@implementation ProfileInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileInterestIsAvailable:) name:@"profileInterestAvailable" object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)profileUI{
    
    NSArray* myarray = self.interestInfo;
    for(id arrayObj in myarray)
    {
        NSLog(@"arraytest%@",arrayObj);
        ProfileInterestInfo* profile = (ProfileInterestInfo*)arrayObj;
        [self.interestTagView addSubview:profile.viewForTags];
        //self.interestTagView.frame = CGRectMake(self.interestTagView.frame.origin.x+50, 0.0,0, 0);
        if ([arrayObj count] > 1) {
            
        }
        self.interestTagView.frame= CGRectMake(self.interestTagView.frame.origin.x, self.interestTagView.frame.origin.y, profile.viewForTags.frame.size.width, profile.viewForTags.frame.size.height);
        
        //NSString *likestr = profile.like;
       // NSInteger likeint = [likestr integerValue];
        /*if (likeint == 1) {*/
            /*for (UIView* sub in self.interestTagView.subviews) {
                [sub removeFromSuperview];
            }*/
            /*[self.interestTagView addSubview:profile.viewForTags];
            
            self.interestTagView.frame= CGRectMake(self.interestTagView.frame.origin.x, self.interestTagView.frame.origin.y, profile.viewForTags.frame.size.width, profile.viewForTags.frame.size.height);
            
        }*/
        /*else if (likeint == 0) {*/
           /* for (UIView* sub in self.notInterestTagView.subviews) {
                [sub removeFromSuperview];
            }*/
            /*[self.notInterestTagView addSubview:profile.viewForTags];
            self.notInterestTagView.frame= CGRectMake(self.notInterestTagView.frame.origin.x, self.notInterestTagView.frame.origin.y, profile.viewForTags.frame.size.width, profile.viewForTags.frame.size.height);
        }*/
        
        
        
    }
   // NSInteger number= 0;
    /*for (int i= 0; i < [myarray count]; i++) {
       ProfileInterestInfo *profileinfo = [[ProfileInterestInfo alloc]init];
        
    }*/
    
    
    // Create the UILabel instance
    
    
    
   /* ProfileInterestInfo* interestInfo = self.interestInfo;
    NSLog(@"uitest%@",interestInfo.name);*/
}
-(void)profileInterestIsAvailable:(NSNotification*)notification{
    self.interestInfo = ((Profile*)notification.userInfo).interests;
    [self profileUI];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
