//
//  Friend.m
//  cruizeco
//
//  Created by One Platinum on 1/25/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "Friend.h"

@implementation Friend
-(Friend*) initWithAttributes:(NSDictionary*)attributes{
    if (![self init]) {
        return [[Friend alloc]init];
    }
    self.friendId =[attributes objectForKey:@"friendId"];
    self.friendUserId = [attributes objectForKey:@"friendUserId"];
    self.invitedBy = [attributes objectForKey:@"invitedBy"];
    self.photo = [NSURL URLWithString:[attributes objectForKey:@"friendPhoto"]];
    return self;
}
@end
