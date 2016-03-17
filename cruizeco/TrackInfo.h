//
//  TrackInfo.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/1/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackInfo : NSObject

@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString* creatorID;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* source;
@property (strong, nonatomic) NSString* destination;
@property (strong, nonatomic) NSString* distance;
@property (strong, nonatomic) NSString* duration;
@property (strong, nonatomic) NSString* rating;
@property (strong, nonatomic) NSString* created;
@property (strong, nonatomic) NSString* trackDescription;




@property (strong, nonatomic) NSMutableArray* polyPoints;
@property (strong, nonatomic) NSMutableArray* markers;



@property (strong, nonatomic) NSMutableArray* events;
@property NSInteger eventCount;

-(TrackInfo*) initWithAttributes:(NSDictionary*) dictionary;
@end

@interface TrackEventInfo : NSObject
@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString* title;
-(TrackEventInfo*) initWithAttributes:(NSDictionary*) dictionary;
@end






@interface TrackPolyInfo : NSObject
@property float longitude;
@property float latitude;
-(TrackPolyInfo*) initWithAttributes:(NSDictionary*) dictionary;
@end



@interface MarkerInfo : NSObject
@property double longitude;
@property double latitude;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* markerDescription;
@property (strong, nonatomic) NSString* type;
-(MarkerInfo*) initWithAttributes:(NSDictionary*) dictionary;
@end


