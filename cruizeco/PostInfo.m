//
//  PostInfo.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "PostInfo.h"

@implementation PostInfo

-(PostInfo*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[PostInfo alloc] init];
    }
    self.postId= [[attributes objectForKey:@"PostId"] integerValue];
    
    self.date= [attributes objectForKey:@"created"];
    if (!self.date) {
        self.date= @"API not providing date";
    }
    self.message= [attributes objectForKey:@"message"];
    
    if (!self.message) {
        self.message= @"API not providing title";
    }
    self.author= [[PostAuthor alloc] initWithAttributes:attributes];
    
    self.commentCount= [[attributes objectForKey:@"commentCount"] integerValue];
    self.comments= [[NSMutableArray alloc] init];
    
    if (self.commentCount > 0) {
        NSInteger startNode= 1;

        for (NSDictionary* comment in [attributes objectForKey:@"comment"]) {
            PostCommentInfo* commentInfo= [[PostCommentInfo alloc] initWithAttributes:comment];
            commentInfo.startNode= startNode;
            commentInfo.endNode= startNode + commentInfo.replyCount;
            startNode= commentInfo.endNode + 1;
            [self.comments addObject:commentInfo];
        }
    }
    
    return self;
}

-(NSInteger) numberOfRepliesAndComments {
    NSInteger replies= 0;
    if (self.commentCount) {
        for (PostCommentInfo* commentInfo in self.comments) {
            replies+= commentInfo.replyCount;
        }
        replies+= self.commentCount;
    }
    return replies;
}



@end



@implementation PostAuthor

-(PostAuthor*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[PostAuthor alloc] init];
    }
    self.name= [attributes objectForKey:@"PostAuthor"];
    self.authorProfilePicture= [NSURL URLWithString:[attributes objectForKey:@"AuthorPhoto"]];
    
    return self;
}
@end



@implementation PostCommentInfo

-(PostCommentInfo*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[PostCommentInfo alloc] init];
    }
    self.commentID= [attributes objectForKey:@"CommentId"];
    self.date= [attributes objectForKey:@"CommentDate"];
    self.message= [attributes objectForKey:@"CommentMessage"];

    self.replyCount= [[attributes objectForKey:@"ReplyCount"] integerValue];
    self.replies= [[NSMutableArray alloc] init];

    
    for (NSDictionary* reply in [attributes objectForKey:@"reply"]) {
        [self.replies addObject:[[PostCommentReplyInfo alloc] initWithAttributes:reply]];
    }
    
    self.author= [[PostCommentAuthorInfo alloc] initWithAttributes:attributes];
    return self;
}
@end

@implementation  PostCommentAuthorInfo

-(PostCommentAuthorInfo*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[PostCommentAuthorInfo alloc] init];
    }
    self.name= [attributes objectForKey:@"CommentUserName"];
    self.authorProfilePicture= [NSURL URLWithString:[attributes objectForKey:@"CommentUserPhoto"]];
    return self;
}

@end



@implementation PostCommentReplyInfo

-(PostCommentReplyInfo*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[PostCommentReplyInfo alloc] init];
    }
    self.replyID= [attributes objectForKey:@"ReplyId"];
    self.date= [attributes objectForKey:@"ReplyDate"];
    if (!self.date) {
        self.date= @"API not providing reply date";
    }
    self.message= [attributes objectForKey:@"ReplyMessage"];
    self.author= [[PostCommentReplyAuthorInfo alloc] initWithAttributes:attributes];
    return self;
}


@end

@implementation PostCommentReplyAuthorInfo

-(PostCommentReplyAuthorInfo*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[PostCommentReplyAuthorInfo alloc] init];
    }
    self.name= [attributes objectForKey:@"ReplyUser"];
    self.authorProfilePicture= [NSURL URLWithString:[attributes objectForKey:@"ReplyUserPhoto"]];
    return self;
}


@end

