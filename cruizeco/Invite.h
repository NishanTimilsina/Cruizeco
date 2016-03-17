//
//  Invite.h
//  cruizeco
//
//  Created by One Platinum on 1/25/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Invite : NSObject
@property (strong,nonatomic) NSString * eventCount;
@property (strong,nonatomic) NSString * friendsCount;
@property(strong,nonatomic)NSString* groupCount;
@property (strong,nonatomic) NSMutableArray * friends;
@property(strong,nonatomic) NSMutableArray * groups;
-(Invite *) initWithAttributes:(NSDictionary*)attributes;

@end
