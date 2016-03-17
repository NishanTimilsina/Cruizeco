//
//  AddTrackViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/2/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "AddTrackViewController.h"
#import <TSMessage.h>

#import "CreateTrackViewController.h"

@interface AddTrackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textDescription;
@property (weak, nonatomic) IBOutlet UITextField *textCategory;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIImageView *ivTextView;
@property (weak, nonatomic) IBOutlet UITextField *textTitle;
@end

@implementation AddTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title= @"Add Route";
}

-(void) setupUI {
    [self leftPaddingViewForTextField:self.textTitle];
    [self rightDropDownViewFor:self.textCategory withImage:[UIImage imageNamed:@"dropDown.png"]];
    
    [self.textDescription.layer setBorderColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor];
    [self.textDescription.layer setBorderWidth:2.0];
    [self.textDescription setBackgroundColor:[UIColor whiteColor]];
    //[self.ivTextView.image= [UIImage imageNamed:@"longtextField.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
//    if (!self.textCategory.text.length || !self.textTitle.text.length || !self.textDescription.text.length) {
//        [TSMessage showNotificationWithTitle:@"Cruizeco" subtitle:@"Track title, description and category is required to progress further" type:TSMessageNotificationTypeWarning];
//        return;
//    }
//    
    CreateTrackViewController* createTrackVC= [self.storyboard instantiateViewControllerWithIdentifier:@"CreateTrackVC"];
    createTrackVC.title= @"Create";
    self.navigationItem.title= @"";
    self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
    [self.navigationController pushViewController:createTrackVC animated:YES];
}

@end
