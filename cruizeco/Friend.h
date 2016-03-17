//
//  Friend.h
//  cruizeco
//
//  Created by One Platinum on 1/25/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject
@property(strong,nonatomic) NSString * friendId;
@property(strong,nonatomic) NSString * friendUserId;
@property(strong,nonatomic) NSString * invitedBy;
@property(strong,nonatomic) NSURL * photo;
-(Friend*) initWithAttributes:(NSDictionary*)attributes;
@end
