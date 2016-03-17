//
//  PendingFriend.m
//  cruizeco
//
//  Created by One Platinum on 1/26/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "PendingFriend.h"

@implementation PendingFriend
-(PendingFriend*)initWithAttributes:(NSDictionary*)attributes{
    if(![self init]){
        return [[PendingFriend alloc]init];
    }
    self.friendId = [attributes objectForKey:@"friendId"];
    self.friendName = [attributes objectForKey:@"friendName"];
    self.friendPhoto = [NSURL URLWithString:[attributes objectForKey:@"friendPhoto"]];
    self.friendEmail = [attributes objectForKey:@"friendEmail"];
    self.friendUserId = [attributes objectForKey:@"friendUserId"];
    return self;
}
@end
