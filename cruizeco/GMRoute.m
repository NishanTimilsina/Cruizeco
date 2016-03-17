//
//  GMRoute.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/3/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "GMRoute.h"
#import "GMRouteLeg.h"


@implementation GMRoute



-(GMRoute*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[GMRoute alloc] init];
    }
    self.summary= [attributes objectForKey:@"summary"];
    self.overviewPolyline= [[attributes objectForKey:@"overview_polyline"] objectForKey:@"points"];
    self.legs= [[NSMutableArray alloc] init];
    for (id obj in [attributes objectForKey:@"legs"]) {
        GMRouteLeg* routeLeg= [[GMRouteLeg alloc] initWithAttributes:obj];
        [self.legs addObject:routeLeg];
        self.distance+= [routeLeg.distanceValue integerValue];
        self.duration+= [routeLeg.durationValue integerValue];
        self.distanceText= routeLeg.distance;
        self.durationText= routeLeg.duration;
    }
    return self;
}

@end
