//
//  CarMake.h
//  cruizeco
//
//  Created by One Platinum on 1/19/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarMake : NSObject
@property(strong,nonatomic)NSString*ID;
@property(strong,nonatomic)NSString*title;

@property (strong, nonatomic) NSMutableArray* models;

-(CarMake*)initWithAttributes:(NSDictionary*)dictionary;
@end
