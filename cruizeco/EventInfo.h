//
//  EventInfo.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventInfo : NSObject

@property NSUInteger eventId;
@property NSUInteger countEventPhoto;
@property NSUInteger countEventPost;
@property NSUInteger countEventTrack;
@property NSUInteger countMembers;
@property NSUInteger hostId;



@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* startDate;
@property (strong, nonatomic) NSString* endDate;
@property (strong, nonatomic) NSString* duration;
@property (strong, nonatomic) NSString* eventDescription;
@property NSString* eventStatus;

@property (strong, nonatomic) NSString* hostName;
@property (strong, nonatomic) NSString* categoryName;

@property (strong, nonatomic) NSURL* categoryIconURL;
@property (strong, nonatomic) NSURL* hostProfilePictureURL;

@property BOOL isHostedByMe;
@property BOOL isJoinedByMe;


@property (strong, nonatomic) NSMutableArray* photos;




-(void) initWithAttributes:(NSDictionary*) dictionary;
    
@end
