//
//  ProfileLocation.m
//  cruizeco
//
//  Created by One Platinum on 2/4/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "ProfileLocation.h"

@implementation ProfileLocation
-(ProfileLocation*)initWithAttributes:(NSDictionary*)attribute{
    if(![self init]){
        return [[ProfileLocation alloc]init];
    }
    self.locationId =[attribute objectForKey:@"locationId"];
    self.location =[attribute objectForKey:@"location"];
    self.locationlat =[attribute objectForKey:@"latitude"];
    self.locationlong =[attribute objectForKey:@"longitude"];
    return self;
}
@end
