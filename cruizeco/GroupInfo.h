//
//  GroupInfo.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfo : NSObject

@property NSUInteger groupId;
@property NSUInteger groupAuthorId;
@property NSUInteger countMembers;
@property NSUInteger countPosts;



@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* groupDescription;
@property (strong, nonatomic) NSString* authorName;

@property (strong, nonatomic) NSURL* photoURL;
@property (strong, nonatomic) NSURL* authorProfilePictureURL;
@property NSInteger postCount;



@property BOOL isHostedByMe;
@property BOOL isAdmin;

//@property (strong, nonatomic) NSMutableArray* members; 


-(GroupInfo*) initWithAttributes:(NSDictionary*) dictionary;

@end
//
//
//@interface MemberInfo : NSObject
//
//@property NSUInteger userId;
//
//@property (strong, nonatomic) NSString* name;
//@property (strong, nonatomic) NSURL* profilePicture;
//
//@end