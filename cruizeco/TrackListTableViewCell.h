//
//  TrackListTableViewCell.h
//  cruizeco
//
//  Created by Kishor Kundan on 8/19/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EDStarRating.h> 

@interface TrackListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTrackTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet EDStarRating *starBox;

@end
