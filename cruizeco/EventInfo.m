//
//  EventInfo.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "EventInfo.h"

@implementation EventInfo

-(instancetype) init {
    if (!self) {
        self= [super init];
    }
    return self;
}

-(void) initWithAttributes:(NSDictionary*) dictionary {
    [self init];

    self.eventId= [[dictionary objectForKey:@"eventId"] integerValue];
    self.countEventPhoto= [[dictionary objectForKey:@"eventPhoto"] count];
    self.countEventPost= [[dictionary objectForKey:@"countEventPost"] integerValue];
    self.countEventTrack= [[dictionary objectForKey:@"countEventTrack"] integerValue];
    self.countMembers= [[dictionary objectForKey:@"members"] integerValue];
    self.hostId= [[dictionary objectForKey:@"HostId"] integerValue];
    
    self.title= [dictionary objectForKey:@"title"];
    self.startDate= [dictionary objectForKey:@"start_date"];
    self.endDate= [dictionary objectForKey:@"end_date"];
    self.duration= [dictionary objectForKey:@"eventDuration"];
    self.eventDescription= [dictionary objectForKey:@"eventDescription"];
    self.eventStatus= [dictionary objectForKey:@"eventStatus"];
    
    self.hostName= [dictionary objectForKey:@"HostName"];
    self.categoryName= [dictionary objectForKey:@"CategoryName"];
    
    self.categoryIconURL= [NSURL URLWithString:[dictionary objectForKey:@"CategoryIcon"]];
    self.hostProfilePictureURL= [NSURL URLWithString:[dictionary objectForKey:@"HostPhoto"]];
    
    self.isHostedByMe= [[dictionary objectForKey:@"isHostedByMe"] boolValue];
    self.isJoinedByMe= [[dictionary objectForKey:@"isJoinedByMe"] boolValue];

    
    self.photos= [[NSMutableArray alloc] initWithCapacity:self.countEventPhoto];
    for (NSString* photo in [dictionary objectForKey:@"eventPhoto"]) {
        [self.photos addObject:[NSURL URLWithString:photo]];
    }
}


@end
