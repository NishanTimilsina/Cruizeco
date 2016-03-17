//
//  UserInfo.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfo : NSObject

@property NSUInteger ID;
@property NSUInteger inviteCount;
@property NSUInteger pendingRequestCount;


@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* profilePictureURL;

@property (strong, nonatomic) NSMutableArray* interests;
@property (strong, nonatomic) NSMutableArray* cars;





@end
