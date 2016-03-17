//
//  Pending.h
//  cruizeco
//
//  Created by One Platinum on 1/26/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pending : NSObject
@property (strong,nonatomic) NSString* eventsCount;
@property (strong,nonatomic) NSString* friendsCount;
@property(strong,nonatomic) NSString* groupsCount;
@property(strong,nonatomic) NSMutableArray* friends;
@property(strong,nonatomic) NSMutableArray* groups;
-(Pending*)initWithAttributes:(NSDictionary*)dictionary;
@end
