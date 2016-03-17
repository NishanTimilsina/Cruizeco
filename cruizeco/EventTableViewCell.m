//
//  EventTableViewCell.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/8/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

- (void)awakeFromNib {
    self.imageEvent.layer.masksToBounds = YES;
    self.imageEvent.layer.cornerRadius= CGRectGetHeight(self.imageEvent.frame)/CGRectGetWidth(self.imageEvent.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showMenu:(id)sender {
    
}



@end
