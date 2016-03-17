//
//  TrackDetailViewController.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/1/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "AppViewController.h"
#import "TrackInfo.h"
@import GoogleMaps;

@interface TrackDetailViewController : AppViewController <UITableViewDataSource, UITableViewDelegate, GMSMapViewDelegate>

@property (strong, nonatomic) TrackInfo* trackInfo;


@end
