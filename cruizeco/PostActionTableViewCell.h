//
//  PostActionTableViewCell.h
//  cruizeco
//
//  Created by Kishor Kundan on 8/18/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostActionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelMoreComments;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIView *viewBorder;

@end
