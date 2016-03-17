//
//  AppDelegate.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/3/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


-(void) changeToProfileView;
-(void) changeToGroupsView;
-(void) changeToEventsView;
-(void) changeToRoutesView;
-(void) changeToFriendsView;



@end

