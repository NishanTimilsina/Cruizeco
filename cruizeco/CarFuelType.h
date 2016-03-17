//
//  CarFuelType.h
//  cruizeco
//
//  Created by One Platinum on 1/19/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarFuelType : NSObject
@property(strong,nonatomic) NSString* fuelTypeId;
@property(strong,nonatomic) NSString* fuelTypeTitle;
-(CarFuelType*) initWithAttributes:(NSDictionary*)dictionary;
@end
