//
//  CarFuelType.m
//  cruizeco
//
//  Created by One Platinum on 1/19/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "CarFuelType.h"

@implementation CarFuelType
-(CarFuelType*) initWithAttributes:(NSDictionary*)dictionary{
    if (![self init]) {
        return [[CarFuelType alloc]init];
    }
    self.fuelTypeId = [dictionary objectForKey:@"fuelTypeId"];
    self.fuelTypeTitle = [dictionary objectForKey:@"fuelTypeTitle"];
    return self;
}
@end
