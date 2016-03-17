//
//  MyFriend.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/9/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "MyFriend.h"


@implementation MyFriend


-(MyFriend*) initWithAttributes:(NSDictionary*) attributes {
    if (![self init]) {
        return [[MyFriend alloc] init];
    }
    
    
    self.facebookID= [attributes objectForKey:@"facebookId"];
    self.friendEmail= [attributes objectForKey:@"friendEmail"];
    self.friendID= [attributes objectForKey:@"friendId"];
    self.friendName= [attributes objectForKey:@"friendName"];
    self.friendInterestCount= [[attributes objectForKey:@"friendInterestCount"] integerValue];
    self.friendPhoto= [NSURL URLWithString:[attributes objectForKey:@"friendPhoto"]];
    self.interests= [[NSMutableArray alloc] init];
    
    self.viewForTags= [[UIView alloc] initWithFrame:CGRectZero];

    if (self.friendInterestCount) {
        float originX= 0;
        float originY= 0;
        float height= 25.0;
        float paddingX= 10.0;
        float paddingY= 5.0;
        float maxWidth= 280;
        for (NSDictionary* interest in [attributes objectForKey:@"interests"]) {
            InterestInfo* interestInfo= [[InterestInfo alloc] initWithAttributes:interest];
            [self.interests addObject:interestInfo];
            UILabel* label= [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 1.0, height)];
            label.text= [NSString stringWithFormat:@"   %@   ", interestInfo.title];
            label.font= [UIFont fontWithName:@"HelveticaNeue" size:12.0];
            label.textColor= [UIColor whiteColor];
            label.backgroundColor= [UIColor colorWithRed:interestInfo.backgroundColor.red green:interestInfo.backgroundColor.green blue:interestInfo.backgroundColor.blue alpha:1.0];
            [label sizeToFit];
            
            CGRect frame= label.frame;
            if (label.frame.size.width+label.frame.origin.x > maxWidth) {
                originX= 0.0;
                originY+= height + paddingY;
                frame.origin.x= originX;
                frame.origin.y= originY;
            }
            frame.size.height+= 10.0;
            label.layer.cornerRadius= frame.size.height/2.0;
            label.layer.masksToBounds= YES;
            [label setFrame:frame];
            originX+= (label.frame.size.width+paddingX);
            [self.viewForTags addSubview:label];
            self.viewForTags.frame= CGRectMake(0.0, 0.0, maxWidth, label.frame.size.height+ label.frame.origin.y + paddingY);
        }

    }
    
    return self;
}


@end
