//
//  PendingFriend.h
//  cruizeco
//
//  Created by One Platinum on 1/26/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingFriend : NSObject
@property(strong,nonatomic)NSString* friendId;
@property(strong,nonatomic)NSString* friendName;
@property(strong,nonatomic)NSURL* friendPhoto;
@property(strong,nonatomic)NSString* friendEmail;
@property(strong,nonatomic)NSString* friendUserId;
-(PendingFriend*)initWithAttributes:(NSDictionary*)attributes;
@end
