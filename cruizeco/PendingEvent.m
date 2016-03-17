//
//  PendingEvent.m
//  cruizeco
//
//  Created by One Platinum on 1/27/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "PendingEvent.h"

@implementation PendingEvent
-(PendingEvent*)initWithAttributes:(NSDictionary *)attributes{
    if(![self init]){
        return [[PendingEvent alloc]init];
    }
    self.eventId=[attributes objectForKey:@"EventId"];
    self.eventName=[attributes objectForKey:@"eventName"];
    self.eventLocation=[attributes objectForKey:@"eventLocation"];
    self.hostedBy = [attributes objectForKey:@"hostedBy"];
    self.hostId = [attributes objectForKey:@"hostId"];
    self.eventUserId = [attributes objectForKey:@"EventUserId"];
    self.countEventPhoto = [attributes objectForKey:@"countEventPhoto"];
    return self;
}
@end
