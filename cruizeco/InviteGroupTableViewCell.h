//
//  InviteGroupTableViewCell.h
//  cruizeco
//
//  Created by One Platinum on 1/28/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *userWithGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;

@end
