//
//  CarMake.m
//  cruizeco
//
//  Created by One Platinum on 1/19/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "CarMake.h"

@implementation CarMake
-(CarMake*)initWithAttributes:(NSDictionary*)dictionary{
    if (![super init]) {
        return [[CarMake alloc] init];
    }
    self.ID=[dictionary objectForKey:@"makeId"];
    self.title = [dictionary objectForKey:@"makeTitle"];
    self.models= [[NSMutableArray alloc] init];
    return self;
}
@end
