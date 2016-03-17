//
//  CarEngineType.h
//  cruizeco
//
//  Created by One Platinum on 1/19/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarEngineType : NSObject
@property(strong,nonatomic)NSString* engineTypeId;
@property(strong,nonatomic)NSString* enginetypeTitle;
-(CarEngineType*) initWithAttributes:(NSDictionary*)dictionary;

@end
