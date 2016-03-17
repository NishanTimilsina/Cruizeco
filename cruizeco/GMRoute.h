//
//  GMRoute.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/3/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GMSPolyline;


@interface GMRoute : NSObject

@property (strong, nonatomic) NSString* summary;
@property (strong, nonatomic) NSString* overviewPolyline;
@property (strong, nonatomic) NSMutableArray* legs;

@property NSInteger distance;
@property NSInteger duration;
@property (strong, nonatomic) NSString* distanceText;
@property (strong, nonatomic) NSString* durationText;
@property BOOL isUserChoice;

@property (strong, nonatomic) GMSPolyline* polyLine;


-(GMRoute*) initWithAttributes:(NSDictionary*) attributes;



@end
