//
//  PendingGroup.h
//  cruizeco
//
//  Created by One Platinum on 1/27/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingGroup : NSObject
@property(strong,nonatomic)NSString* groupId;
@property(strong,nonatomic)NSString* groupUserId;
@property(strong,nonatomic)NSString* hostedByMe;
@property(strong,nonatomic)NSString* groupName;
@property(strong,nonatomic)NSString* invitee;
@property(strong,nonatomic)NSString* inviteeId;
@property(strong,nonatomic)NSString* request;
@property(strong,nonatomic)NSURL* groupPhoto;
@property(strong,nonatomic)NSString* groupType;
@property(strong,nonatomic)NSString* message;
-(PendingGroup*)initWithAttributes:(NSDictionary*)attributes;
@end
