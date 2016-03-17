//
//  Invite.m
//  cruizeco
//
//  Created by One Platinum on 1/25/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "Invite.h"
#import "Friend.h"
#import "Group.h"

@implementation Invite
-(Invite *) initWithAttributes:(NSDictionary*)dictionary{
    if (![self init]) {
        return [[Invite alloc] init];
    }
    self.eventCount = [dictionary objectForKey:@"countEvents"];
    self.friendsCount = [dictionary objectForKey:@"countFriends"];
    self.groupCount = [dictionary objectForKey:@"countGroups"];
    self.friends = [[NSMutableArray alloc]init];
    if (self.friendsCount) {
        for (id attribute in[dictionary objectForKey:@"Friends"]){
            Friend* friend = [[Friend alloc]initWithAttributes:attribute];
            [self.friends addObject:friend];
        }
    }
    self.groups =[[NSMutableArray alloc]init];
    if(self.groupCount){
        for (id attribute in[dictionary objectForKey:@"Groups"]){
            Group* group = [[Group alloc]initWithAttributes:attribute];
            [self.groups addObject:group];
        }
    }
    return self;
}
@end
