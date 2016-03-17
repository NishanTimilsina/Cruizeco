//
//  MyFriend.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/9/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterestInfo.h"
#import <UIKit/UIKit.h>

@interface MyFriend : NSObject

@property (strong, nonatomic) NSString* facebookID;
@property (strong, nonatomic) NSString* friendEmail;
@property (strong, nonatomic) NSString* friendID;
@property (strong, nonatomic) NSString* friendName;
@property NSInteger friendInterestCount;

@property (strong, nonatomic) NSURL* friendPhoto;
@property (strong, nonatomic) UIView* viewForTags;
@property (strong, nonatomic) NSMutableArray* interests;
@property BOOL isSelected;

-(MyFriend*) initWithAttributes:(NSDictionary*) attributes;

@end
