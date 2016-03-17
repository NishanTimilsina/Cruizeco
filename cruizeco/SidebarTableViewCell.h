//
//  SidebarTableViewCell.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/4/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivArrow;
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;

@end
