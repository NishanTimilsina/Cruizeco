//
//  GMRouteLegStep.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/3/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GMRouteLegStep : NSObject

@property (strong, nonatomic) NSString* distance;
@property (strong, nonatomic) NSString* distanceValue;

@property (strong, nonatomic) NSString* duration;
@property (strong, nonatomic) NSString* durationValue;

@property (strong, nonatomic) NSString* htmlInstructions;
@property (strong, nonatomic) NSString* travelMode;

@property (strong, nonatomic) NSString* maneuver;
@property (strong, nonatomic) NSString* polyLine;

@property CLLocationCoordinate2D origin;
@property CLLocationCoordinate2D destination;

-(GMRouteLegStep*) initWithAttributes:(NSDictionary*) attributes;
@end
