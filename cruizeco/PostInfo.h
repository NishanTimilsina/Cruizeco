//
//  PostInfo.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PostAuthor;
@class PostCommentAuthorInfo;
@class PostCommentReplyAuthorInfo;


@interface PostInfo : NSObject


@property NSUInteger postId;
@property NSUInteger commentCount;
@property (strong, nonatomic) NSString* date;

@property (strong, nonatomic) NSString* message;

@property (strong, nonatomic) PostAuthor* author;

@property (strong, nonatomic) NSMutableArray* comments;


-(PostInfo*) initWithAttributes:(NSDictionary*) attributes;
-(NSInteger) numberOfRepliesAndComments;


@end


@interface PostAuthor : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* authorProfilePicture;

-(PostAuthor*) initWithAttributes:(NSDictionary*) attributes;

@end


@interface PostCommentInfo : NSObject

@property (strong, nonatomic) NSString* commentID;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString* message;
@property NSInteger replyCount;

@property (strong, nonatomic) PostCommentAuthorInfo* author;
@property (strong, nonatomic) NSMutableArray* replies;

@property NSInteger startNode;
@property NSInteger endNode;

-(PostCommentInfo*) initWithAttributes:(NSDictionary*) attributes;
@end

@interface PostCommentAuthorInfo : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* authorProfilePicture;
-(PostCommentAuthorInfo*) initWithAttributes:(NSDictionary*) attributes;

@end


@interface PostCommentReplyInfo : NSObject

@property (strong, nonatomic) NSString* replyID;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString* message;

@property (strong, nonatomic) PostCommentReplyAuthorInfo* author;

-(PostCommentReplyInfo*) initWithAttributes:(NSDictionary*) attributes;
@end

@interface PostCommentReplyAuthorInfo : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* authorProfilePicture;
-(PostCommentReplyAuthorInfo*) initWithAttributes:(NSDictionary*) attributes;

@end



