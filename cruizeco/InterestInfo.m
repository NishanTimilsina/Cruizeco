//
//  InterestInfo.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "InterestInfo.h"

@implementation InterestInfo


-(InterestInfo*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[InterestInfo alloc] init];
    }
    
    self.title= [attributes objectForKey:@"name"];
    NSString* rgbString= [[attributes objectForKey:@"interestColor"] substringWithRange:NSMakeRange(1, [[attributes objectForKey:@"interestColor"] length] - 2)];
    NSLog(@"logging rgb string %@", rgbString);
    
    NSArray* rgbArray= [rgbString  componentsSeparatedByString: @","];
    
    interestBackgroundColor backgroundColor= {[rgbArray[0] intValue]/255.0,[rgbArray[1] intValue]/255.0, [rgbArray[2] intValue]/255.0};
    self.backgroundColor= backgroundColor;
    
    return self;
    
}

@end
