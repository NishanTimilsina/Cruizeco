//
//  CruizeCategory.h
//  cruizeco
//
//  Created by Kishor Kundan on 12/8/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CruizeCategory : NSObject

@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSURL* icon;


-(CruizeCategory*) initWithAttributes:(NSDictionary*) attributes;

@end
