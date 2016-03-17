//
//  ProfileInterestInfo.m
//  cruizeco
//
//  Created by One Platinum on 2/4/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "ProfileInterestInfo.h"

@implementation ProfileInterestInfo
-(ProfileInterestInfo*) initWithAttributes:(NSDictionary*)attributes{
    if (![self init]) {
        return [[ProfileInterestInfo alloc]init];
    }
    self.name =[attributes objectForKey:@"name"];
    self.interestId = [attributes objectForKey:@"interestId"];
    NSString* rgbString= [[attributes objectForKey:@"interestColor"] substringWithRange:NSMakeRange(1, [[attributes objectForKey:@"interestColor"] length] - 2)];
    NSLog(@"logging rgb string %@", rgbString);
    
    NSArray* rgbArray= [rgbString  componentsSeparatedByString: @","];
    
    interestBackgroundColor backgroundColor= {[rgbArray[0] intValue]/255.0,[rgbArray[1] intValue]/255.0, [rgbArray[2] intValue]/255.0};
    self.backgroundColor= backgroundColor;
    self.like = [attributes objectForKey:@"liked"];
    self.viewForTags= [[UIView alloc] initWithFrame:CGRectZero];
    
    float originX= 0;
    /*if (self.viewForTags >1) {
        originX = originX + 50;
    }
    else{
        NSLog(@"less");
    }*/
    float originY= 0;
    float height= 25.0;
    float paddingX= 10.0;
    float paddingY= 15.0;
    float maxWidth= 400;
    UILabel* label= [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 1.0, height)];
    label.text= [NSString stringWithFormat:@"   %@   ", self.name];
    label.font= [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    label.textColor= [UIColor whiteColor];
    label.backgroundColor= [UIColor colorWithRed:self.backgroundColor.red green:self.backgroundColor.green blue:self.backgroundColor.blue alpha:1.0];

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
    //self.viewForTags.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    originX+= (label.frame.size.width+paddingX);
    [self.viewForTags addSubview:label];
    //self.viewForTags.frame= CGRectMake(0.0, 25.0, maxWidth, label.frame.size.height+ label.frame.origin.y + paddingY);
    
    self.viewForTags.frame = CGRectMake(0, 0,CGRectGetWidth(self.viewForTags.bounds),CGRectGetHeight(self.viewForTags.bounds));
    //self.viewForTags.frame = CGRectMake(self.viewForTags.frame.origin.x,
                                 // self.viewForTags.frame.origin.y + self.viewForTags.frame.size.height,
                                  //self.viewForTags.frame.size.width,
                                  //self.viewForTags.frame.size.height);
    
    return self;
}
@end
