//
//  AddFriendViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 8/19/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancel:(id)sender {
}
- (IBAction)search:(id)sender {
}

@end
