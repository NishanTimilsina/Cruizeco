//
//  CarInfo.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "CarInfo.h"

@implementation CarInfo

-(CarInfo*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[CarInfo alloc] init];
    }
    
    
    self.ID= [attributes objectForKey:@"id"];
    self.name= [attributes objectForKey:@"name"];
    self.makeId= [attributes objectForKey:@"makeId"];
    self.makeTitle= [attributes objectForKey:@"make"];
    self.model= [attributes objectForKey:@"model"];
    self.modelId= [attributes objectForKey:@"modelId"];
    self.engineTypeId= [attributes objectForKey:@"engineTypeId"];
    self.engineType= [attributes objectForKey:@"engine_type"];
    self.fuelType= [attributes objectForKey:@"fuel_type"];
    self.fuelTypeId= [attributes objectForKey:@"fuelTypeId"];
    self.makeYear= [attributes objectForKey:@"year"];
    self.descripionText= [attributes objectForKey:@"description"];
    self.modificationText= [attributes objectForKey:@"modification"];
    
    self.createdTime= [attributes objectForKey:@"created"];
    self.imageCount= [[attributes objectForKey:@"imageCount"] integerValue];
    self.images= [[NSMutableArray alloc] init];
    if (self.imageCount) {
        for (id object in [attributes objectForKey:@"images"]) {
            [self.images addObject:[NSURL URLWithString:[object objectForKey:@"url"]]];
        }
    }
    /*
    $user["name"] -> [user objectForKey:@"name"]; => associate array/ key value pair (NSDictionary, NSMutableDictionary)
    $users[]= $user; -> [users objectAtIndex:0] => Array (NSArray, NSMutableArray)
     */
    return self;
}

@end
