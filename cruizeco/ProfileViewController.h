//
//  ProfileViewController.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/6/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "AppViewController.h"
#import "Profile.h"

@interface ProfileViewController : AppViewController

@property (strong, nonatomic) UINavigationController* navigationController;

@property (strong,nonatomic) Profile*profileInfo;



@end
