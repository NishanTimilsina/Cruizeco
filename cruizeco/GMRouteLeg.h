//
//  GMRouteLeg.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/3/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GMRouteLeg : NSObject

@property (strong, nonatomic) NSString* distance;
@property (strong, nonatomic) NSString* duration;

@property (strong, nonatomic) NSString* distanceValue;
@property (strong, nonatomic) NSString* durationValue;

@property (strong, nonatomic) NSString* startAdress;
@property (strong, nonatomic) NSString* endAdress;

@property (strong, nonatomic) NSMutableArray* steps;

@property CLLocationCoordinate2D origin;
@property CLLocationCoordinate2D destination;


-(GMRouteLeg*) initWithAttributes:(NSDictionary*) attributes;




@end
