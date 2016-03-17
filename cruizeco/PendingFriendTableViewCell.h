//
//  PendingFriendTableViewCell.h
//  cruizeco
//
//  Created by One Platinum on 1/25/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pendingImage;
@property (weak, nonatomic) IBOutlet UILabel *pendingName;
@property (weak, nonatomic) IBOutlet UIButton *btnPendingCancel;
@property (weak, nonatomic) IBOutlet UILabel *requestNotAccepted;

@end
