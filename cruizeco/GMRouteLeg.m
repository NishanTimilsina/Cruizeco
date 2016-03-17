//
//  GMRouteLeg.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/3/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "GMRouteLeg.h"
#import "GMRouteLegStep.h"

@implementation GMRouteLeg



-(GMRouteLeg*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[GMRouteLeg alloc] init];
    }
    
    self.distance= [[attributes objectForKey:@"distance"] objectForKey:@"text"];
    self.distanceValue= [[attributes objectForKey:@"distance"] objectForKey:@"value"];
    self.duration= [[attributes objectForKey:@"duration"] objectForKey:@"text"];
    self.durationValue= [[attributes objectForKey:@"duration"] objectForKey:@"value"];
    
    self.startAdress= [attributes objectForKey:@"start_address"];
    self.endAdress= [attributes objectForKey:@"end_address"];
    
    self.origin= CLLocationCoordinate2DMake([[[attributes objectForKey:@"start_location"] objectForKey:@"lat"] doubleValue], [[[attributes objectForKey:@"start_location"] objectForKey:@"lng"] doubleValue]);
    self.destination= CLLocationCoordinate2DMake([[[attributes objectForKey:@"end_location"] objectForKey:@"lat"] doubleValue], [[[attributes objectForKey:@"end_location"] objectForKey:@"lng"] doubleValue]);
    
    self.steps= [[NSMutableArray alloc] init];
    for (id object in [attributes objectForKey:@"legs"]) {
        [self.steps addObject:[[GMRouteLegStep alloc] initWithAttributes:object]];
    }
    
    return self;
}
@end
