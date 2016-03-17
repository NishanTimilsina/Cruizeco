//
//  Profile.h
//  cruizeco
//
//  Created by One Platinum on 1/11/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Profile : NSObject

@property NSUInteger inviteCount;
@property NSUInteger requestPendingCount;
@property (strong,nonatomic) NSURL* myPhoto;

@property (strong, nonatomic) NSString* me;

@property NSInteger carCount;
@property (strong, nonatomic) NSMutableArray* cars;
@property(strong,nonatomic) NSMutableArray* interests;
@property NSInteger interestCount;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSDictionary * place;
@property (strong, nonatomic) UIView* viewForTags;
@property NSUInteger locationCount;
@property(strong,nonatomic)NSMutableArray* locations;
-(Profile*) initWithAttribute:(NSDictionary*)dictionary;
@end
