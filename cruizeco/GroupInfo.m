//
//  GroupInfo.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "GroupInfo.h"

@implementation GroupInfo

-(GroupInfo*) initWithAttributes:(NSDictionary*) dictionary {
    if (![super init]) {
        return [[GroupInfo alloc] init];
    }
    
    
    self.groupId= [[dictionary objectForKey:@"groupId"] integerValue];
    self.groupAuthorId= [[dictionary objectForKey:@"hostId"] integerValue];
    self.countMembers= [[dictionary objectForKey:@"countMembers"] integerValue];
    self.countPosts= [[dictionary objectForKey:@"countPosts"] integerValue];;
    
    
    
    self.name= [dictionary objectForKey:@"groupTitle"];
    self.groupDescription= [dictionary objectForKey:@"groupDescription"];
    self.authorName= [dictionary objectForKey:@"hostName"];
    
    self.photoURL= [NSURL URLWithString:[dictionary objectForKey:@"groupPhoto"]];
    self.authorProfilePictureURL= [NSURL URLWithString:[dictionary objectForKey:@"hostPhoto"]];
    
    
    self.isHostedByMe= [[dictionary objectForKey:@"isHostedByMe"] boolValue];
    self.isAdmin= [[dictionary objectForKey:@"isAdmin"] boolValue];

    return self;
}

@end
