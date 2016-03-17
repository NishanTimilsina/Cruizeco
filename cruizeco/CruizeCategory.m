//
//  CruizeCategory.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/8/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "CruizeCategory.h"

@implementation CruizeCategory


-(CruizeCategory*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[CruizeCategory alloc] init];
    }
    self.ID= [attributes objectForKey:@"categoryId"];
    self.title= [attributes objectForKey:@"categoryTitle"];
    self.icon= [NSURL URLWithString:[attributes objectForKey:@"categoryIcon"]];
    return self;
}
@end
