//
//  ProfileInterestInfo.h
//  cruizeco
//
//  Created by One Platinum on 2/4/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct {
    float red;
    float green;
    float blue;
}interestBackgroundColor;
@interface ProfileInterestInfo : NSObject
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* interestId;
@property (assign, nonatomic) interestBackgroundColor backgroundColor;
@property(strong,nonatomic) NSString* like;
@property (strong, nonatomic) UIView* viewForTags;
-(ProfileInterestInfo*) initWithAttributes:(NSDictionary*)attributes;
@end
