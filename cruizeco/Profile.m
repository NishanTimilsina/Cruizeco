//
//  Profile.m
//  cruizeco
//
//  Created by One Platinum on 1/11/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "Profile.h"
#import "CarInfo.h"
#import "ProfileLocation.h"
#import "ProfileInterestInfo.h"

@implementation Profile
-(Profile*) initWithAttribute:(NSDictionary*) dictionary{
    if (![super init]) {
        return [[Profile alloc] init];
    }
    self.inviteCount = [[dictionary objectForKey:@"inviteCount"]integerValue];
    self.requestPendingCount =[[dictionary objectForKey:@"requestPendingCount"]integerValue];
    self.myPhoto= [NSURL URLWithString:[dictionary objectForKey:@"myPhoto"]];
    self.me =[dictionary objectForKey:@"me"];
    self.carCount= [[dictionary objectForKey:@"carCount"] integerValue];
    self.locationCount = [[dictionary objectForKey:@"locationCount"]integerValue];
    
    self.cars= [[NSMutableArray alloc] init];
    if (self.carCount) {
        for (id attribute in [dictionary objectForKey:@"Cars"]) {
            CarInfo* carInfo= [[CarInfo alloc] initWithAttributes:attribute];
            [self.cars addObject:carInfo];
        }
    }
    
    self.locations= [[NSMutableArray alloc] init];
    if (self.locationCount) {
        for (id attribute in [dictionary objectForKey:@"Locations"]) {
            ProfileLocation* locationInfo= [[ProfileLocation alloc] initWithAttributes:attribute];
            [self.locations addObject:locationInfo];
        }
    }
    self.name =[dictionary objectForKey:@"name"];
    self.interestCount = [[dictionary objectForKey:@"interestCount"]integerValue];
    self.interests = [[NSMutableArray alloc]init];
    if (self.interestCount) {
        for (id attribute in [dictionary objectForKey:@"Interests"]) {
            ProfileInterestInfo* interestInfo = [[ProfileInterestInfo alloc] initWithAttributes:attribute];
            [self.interests addObject:interestInfo];
        }
    }
    /*self.viewForTags = [[UIView alloc] initWithFrame:CGRectZero];
    if (self.interestCount) {
        float originX= 0;
        float originY= 0;
        float height= 25.0;
        float paddingX= 10.0;
        float paddingY= 5.0;
        float maxWidth= 280;
        for (id attribute in[dictionary objectForKey:@"Interests"]){
            ProfileInterestInfo* interestInfo = [[ProfileInterestInfo alloc] initWithAttributes:attribute];
            [self.interests addObject:interestInfo];
            UILabel* label= [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 1.0, height)];
            label.text= [NSString stringWithFormat:@"   %@   ", interestInfo.name];
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
    }*/
    return self;
}

@end
