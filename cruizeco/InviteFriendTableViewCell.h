//
//  InviteFriendTableViewCell.h
//  cruizeco
//
//  Created by One Platinum on 1/25/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *friendPhoto;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *requestWithName;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;

@end
