//
//  TrackInfo.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/1/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "TrackInfo.h"


@implementation TrackInfo


-(TrackInfo*) initWithAttributes:(NSDictionary*) dictionary {
    if (![super init]) {
        return [[TrackInfo alloc] init];
    }
    self.ID= [dictionary objectForKey:@"trackId"];
    self.creatorID= [dictionary objectForKey:@"trackCreatorId"];
    self.title= [dictionary objectForKey:@"trackTitle"];
    self.source= [dictionary objectForKey:@"trackSource"];
    self.destination= [dictionary objectForKey:@"trackDestination"];
    self.distance= [dictionary objectForKey:@"trackDistance"];
    self.duration= [dictionary objectForKey:@"trackDuration"];
    self.rating= [dictionary objectForKey:@"trackRating"];
    self.created= [dictionary objectForKey:@"trackCreated"];
    
    self.events= [[NSMutableArray alloc] init];
    self.eventCount= [[dictionary objectForKey:@"eventCount"] integerValue];
    
    if (self.eventCount) {
        for (id object in [dictionary objectForKey:@"event"]) {
            TrackEventInfo* trackEventInfo= [[TrackEventInfo alloc] initWithAttributes:object];
            [self.events addObject:trackEventInfo];
        }
    }
    self.polyPoints= [[NSMutableArray alloc] init];
    NSString* poly= [[dictionary objectForKey:@"trackPath"] objectForKey:@"track"];
    if (poly) {
        for (id object in [[dictionary objectForKey:@"trackPath"] objectForKey:@"track"]) {
            TrackPolyInfo* polyInfo= [[TrackPolyInfo alloc] initWithAttributes:object];
            [self.polyPoints addObject:polyInfo];
        }
    }
    
    
    self.markers= [[NSMutableArray alloc] init];
    NSString* marker= [[dictionary objectForKey:@"trackPath"] objectForKey:@"marker"];
    if (marker) {
        for (id object in [[dictionary objectForKey:@"trackPath"] objectForKey:@"marker"]) {
            MarkerInfo* polyInfo= [[MarkerInfo alloc] initWithAttributes:object];
            [self.markers addObject:polyInfo];
        }
    }
    
    return self;
}

@end


@implementation TrackEventInfo

-(TrackEventInfo*) initWithAttributes:(NSDictionary*) dictionary {
    if (![super init]) {
        return [[TrackEventInfo alloc] init];
    }
    self.ID= [dictionary objectForKey:@"eventId"];
    self.title= [dictionary objectForKey:@"eventTitle"];
    return self;
}

@end



@implementation TrackPolyInfo

-(TrackPolyInfo*) initWithAttributes:(NSDictionary*) dictionary {
    if (![super init]) {
        return [[TrackPolyInfo alloc] init];
    }
    self.longitude= [[dictionary objectForKey:@"long"] floatValue];
    self.latitude= [[dictionary objectForKey:@"lat"] floatValue];
    return self;
}

@end



@implementation MarkerInfo

-(MarkerInfo*) initWithAttributes:(NSDictionary*) dictionary {
    if (![super init]) {
        return [[MarkerInfo alloc] init];
    }
    self.longitude= [[dictionary objectForKey:@"long"] floatValue];
    self.latitude= [[dictionary objectForKey:@"lat"] floatValue];
    self.title= [dictionary objectForKey:@"title"];
    self.markerDescription= [dictionary objectForKey:@"desc"];
    
    return self;
}

@end
