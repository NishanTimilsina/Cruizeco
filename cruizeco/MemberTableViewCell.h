//
//  MemberTableViewCell.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/9/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivMemberPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelMemberName;
@property (weak, nonatomic) IBOutlet UIView *viewTags;

@end
