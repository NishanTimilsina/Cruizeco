//
//  GMRouteLegStep.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/3/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "GMRouteLegStep.h"

@implementation GMRouteLegStep


-(GMRouteLegStep*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[GMRouteLegStep alloc] init];
    }
    self.distance= [[attributes objectForKey:@"distance"] objectForKey:@"text"];
    self.distanceValue= [[attributes objectForKey:@"distance"] objectForKey:@"value"];
    self.duration= [[attributes objectForKey:@"duration"] objectForKey:@"text"];
    self.durationValue= [[attributes objectForKey:@"duration"] objectForKey:@"value"];
    
    self.htmlInstructions= [attributes objectForKey:@"html_instructions"];
    self.travelMode= [attributes objectForKey:@"travel_mode"];
    
    self.maneuver= [attributes objectForKey:@"maneuver"];
    self.polyLine= [[attributes objectForKey:@"polyline"] objectForKey:@"points"];
    
    self.origin= CLLocationCoordinate2DMake([[[attributes objectForKey:@"start_location"] objectForKey:@"lat"] doubleValue], [[[attributes objectForKey:@"start_location"] objectForKey:@"lng"] doubleValue]);
    self.destination= CLLocationCoordinate2DMake([[[attributes objectForKey:@"end_location"] objectForKey:@"lat"] doubleValue], [[[attributes objectForKey:@"end_location"] objectForKey:@"lng"] doubleValue]);
    return self;
}

@end
