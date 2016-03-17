//
//  UIButton+Block.h
//  2H
//
//  Created by Kishor Kundan on 12/22/14.
//  Copyright (c) 2014 One Platinum. All rights reserved.
//

#define kUIButtonBlockTouchUpInside @"TouchInside"

#import <UIKit/UIKit.h>

@interface UIButton (Block)

@property (nonatomic, strong) NSMutableDictionary *actions;

- (void) setAction:(NSString*)action withBlock:(void(^)(UIButton* sender))block;

@end