//
//  PendingGroup.m
//  cruizeco
//
//  Created by One Platinum on 1/27/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "PendingGroup.h"

@implementation PendingGroup
-(PendingGroup*)initWithAttributes:(NSDictionary *)attributes{
    if (![self init]) {
        return [[PendingGroup alloc]init];
    }
    self.groupId =[attributes objectForKey:@"groupId"];
    self.groupUserId =[attributes objectForKey:@"groupUserId"];
    self.hostedByMe =[attributes objectForKey:@"isHostedByMe"];
    self.groupName =[attributes objectForKey:@"groupName"];
    self.groupPhoto =[NSURL URLWithString:[attributes objectForKey:@"groupPhoto"]];
    self.invitee =[attributes objectForKey:@"invitee"];
    self.inviteeId =[attributes objectForKey:@"inviteeId"];
    self.request =[attributes objectForKey:@"request"];
    self.groupType =[attributes objectForKey:@"groupType"];
    self.message =[attributes objectForKey:@"message"];
    return self;
}
@end
