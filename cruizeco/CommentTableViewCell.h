//
//  CommentTableViewCell.h
//  cruizeco
//
//  Created by Kishor Kundan on 8/18/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *authorPhoto;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property (weak, nonatomic) IBOutlet UIButton *btnReply;

@end
