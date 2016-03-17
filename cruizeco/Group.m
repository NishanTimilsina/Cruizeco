//
//  Group.m
//  cruizeco
//
//  Created by One Platinum on 1/28/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "Group.h"

@implementation Group
-(Group*)initWithAttributes:(NSDictionary*)attributes{
    if(![self init]){
        return [[Group alloc]init];
    }
    self.groupId =[attributes objectForKey:@"groupId"];
    self.groupName = [attributes objectForKey:@"groupName"];
    self.groupPhoto = [NSURL URLWithString:[attributes objectForKey:@"groupPhoto"]];
    self.invitedBy = [attributes objectForKey:@"invitedBy"];
    self.invitedById = [attributes objectForKey:@"invitedById"];
    self.groupUserId = [attributes objectForKey:@"groupUserId"];
    self.isHostedBy = [attributes objectForKey:@"isHostedByMe"];
    return self;
}
@end
