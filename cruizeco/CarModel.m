//
//  CarModel.m
//  cruizeco
//
//  Created by One Platinum on 1/19/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel


-(CarModel*) initWithAttributes:(NSDictionary*) dictionary {
    if (![self init]) {
        return [[CarModel alloc] init];
    }
    self.makeId= [dictionary objectForKey:@"makeId"];
    self.modelId= [dictionary objectForKey:@"modelId"];
    self.title= [dictionary objectForKey:@"modelTitle"];
    
    return self;
}
@end
