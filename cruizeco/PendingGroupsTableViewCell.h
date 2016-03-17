//
//  PendingGroupsTableViewCell.h
//  cruizeco
//
//  Created by One Platinum on 1/27/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingGroupsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
@end
