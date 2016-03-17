//
//  PendingEvent.h
//  cruizeco
//
//  Created by One Platinum on 1/27/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingEvent : NSObject
@property(strong,nonatomic)NSString* eventId;
@property(strong,nonatomic)NSString* eventName;
@property(strong,nonatomic)NSString* eventLocation;
@property(strong,nonatomic)NSString* hostedBy;
@property(strong,nonatomic)NSString* eventUserId;
@property(strong,nonatomic)NSString* countEventPhoto;
@property(strong,nonatomic)NSMutableArray* eventPhoto;
@property(strong,nonatomic)NSString* hostId;
-(PendingEvent*)initWithAttributes:(NSDictionary*)attributes;
@end
