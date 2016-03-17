//
//  InterestInfo.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef struct {
    float red;
    float green;
    float blue;
}interestBackgroundColor;

@interface InterestInfo : NSObject


@property (strong, nonatomic) NSString* title;
/*@property (strong,nonatomic) NSString* interestId;
@property (strong,nonatomic) NSString* interestUserId;
@property (strong,nonatomic) NSString* like;*/

@property (assign, nonatomic) interestBackgroundColor backgroundColor;


-(InterestInfo*) initWithAttributes:(NSDictionary*) attributes;
@end
