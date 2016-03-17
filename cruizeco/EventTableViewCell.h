//
//  EventTableViewCell.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/8/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageEvent;
@property (weak, nonatomic) IBOutlet UILabel *labelEventTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonAction;
@property (weak, nonatomic) IBOutlet UILabel *labelMembers;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;

@property (weak, nonatomic) IBOutlet UIImageView *imageDuration;
@property (weak, nonatomic) IBOutlet UIImageView *imageDistance;
@property (weak, nonatomic) IBOutlet UIButton *buttonDropDown;

@property (weak, nonatomic) IBOutlet UIImageView *imageMember;
@property (weak, nonatomic) IBOutlet UILabel *labelEventDescription;


@end
