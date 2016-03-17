//
//  CarInfo.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarInfo : NSObject


@property (strong, nonatomic) NSString* ID;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* makeId;
@property (strong, nonatomic) NSString* makeTitle;
@property (strong, nonatomic) NSString* modelId;
@property (strong, nonatomic) NSString* model;
@property (strong, nonatomic) NSString* engineTypeId;
@property (strong, nonatomic) NSString* engineType;
@property (strong, nonatomic) NSString* fuelType;
@property (strong, nonatomic) NSString* fuelTypeId;
@property (strong, nonatomic) NSString* makeYear;
@property (strong, nonatomic) NSString* descripionText;
@property (strong, nonatomic) NSString* modificationText;

@property (strong, nonatomic) NSString* createdTime;
@property NSInteger imageCount;
@property (strong, nonatomic) NSMutableArray* images;


-(CarInfo*) initWithAttributes:(NSDictionary*) attributes;


@end
