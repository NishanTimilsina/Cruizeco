//
//  Group.h
//  cruizeco
//
//  Created by One Platinum on 1/28/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject
@property(strong,nonatomic)NSString* groupId;
@property(strong,nonatomic)NSString* groupName;
@property(strong,nonatomic)NSURL* groupPhoto;
@property(strong,nonatomic)NSString* invitedBy;
@property(strong,nonatomic)NSString* invitedById;
@property(strong,nonatomic)NSString* groupUserId;
@property(strong,nonatomic)NSString* isHostedBy;
-(Group*)initWithAttributes:(NSDictionary*)attributes;
@end
