//
//  Pending.m
//  cruizeco
//
//  Created by One Platinum on 1/26/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "Pending.h"
#import "PendingFriend.h"
#import "PendingGroup.h"

@implementation Pending
-(Pending*)initWithAttributes:(NSDictionary*)dictionary{
    if(![self init]){
        return [[Pending alloc]init];
    }
    self.eventsCount = [dictionary objectForKey:@"countEvents"];
    self.friendsCount = [dictionary objectForKey:@"countFriends"];
    self.groupsCount = [dictionary objectForKey:@"countGroups"];
    self.friends = [[NSMutableArray alloc]init];
    if(self.friendsCount)
    {
        for (id attributes in[dictionary objectForKey:@"Friends"]) {
            PendingFriend* pendingFriend = [[PendingFriend alloc]initWithAttributes:attributes];
            [self.friends addObject:pendingFriend];
        }
    }
    self.groups = [[NSMutableArray alloc]init];
    if(self.groupsCount)
    {
        for(id attributes in[dictionary objectForKey:@"Groups"])
        {
            PendingGroup* pendingGroup = [[PendingGroup alloc]initWithAttributes:attributes];
            [self.groups addObject:pendingGroup];
        }
    }
    return self;
}
@end
