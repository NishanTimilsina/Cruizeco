//
//  GroupDetailViewController.h
//  cruizeco
//
//  Created by Kishor Kundan on 8/14/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "AppViewController.h"
#import "GroupInfo.h"

@interface GroupDetailViewController : AppViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property BOOL removePreviousViewFromNavigationStack;
@property (strong, nonatomic) NSString* groupId;
@property (strong, nonatomic) GroupInfo* groupInfo;

@end
