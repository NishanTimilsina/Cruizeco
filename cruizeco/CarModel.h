//
//  CarModel.h
//  cruizeco
//
//  Created by One Platinum on 1/19/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarModel : NSObject

@property(strong,nonatomic)NSString* makeId;
@property(strong,nonatomic)NSString* modelId;
@property(strong,nonatomic)NSString* title;

-(CarModel*) initWithAttributes:(NSDictionary*) dictionary;

@end
