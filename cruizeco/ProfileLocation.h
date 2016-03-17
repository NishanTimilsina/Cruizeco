//
//  ProfileLocation.h
//  cruizeco
//
//  Created by One Platinum on 2/4/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileLocation : NSObject
@property(strong,nonatomic) NSString* locationId;
@property(strong,nonatomic) NSString* location;
@property(strong,nonatomic) NSString* locationlat;
@property(strong,nonatomic) NSString* locationlong;
-(ProfileLocation*)initWithAttributes:(NSDictionary*)attribute;
@end
