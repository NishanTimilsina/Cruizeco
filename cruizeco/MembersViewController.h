//
//  MembersViewController.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/9/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "AppViewController.h"

@interface MembersViewController : AppViewController <UITableViewDataSource, UITableViewDelegate>

@property BOOL isSelectionForGroup;
@property (strong, nonatomic) NSString* groupId;

@end
