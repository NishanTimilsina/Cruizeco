//
//  TrackCommentTableViewCell.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/1/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *ivCommentor;
@property (weak, nonatomic) IBOutlet UILabel *commentTitle;
@property (weak, nonatomic) IBOutlet UILabel *commentDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UIImageView *ivClock;
@end
