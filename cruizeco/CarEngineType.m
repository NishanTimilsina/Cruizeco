//
//  CarEngineType.m
//  cruizeco
//
//  Created by One Platinum on 1/19/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "CarEngineType.h"

@implementation CarEngineType
-(CarEngineType*) initWithAttributes:(NSDictionary*)dictionary{
    if(![self init]){
        return [[CarEngineType alloc]init];
    }
    self.engineTypeId = [dictionary objectForKey:@"engineTypeId"];
    self.enginetypeTitle = [dictionary objectForKey:@"engineTypeTitle"];
    return self;
}
@end
