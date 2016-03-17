//
//  ProfileLocationViewController.m
//  cruizeco
//
//  Created by One Platinum on 2/3/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "ProfileLocationViewController.h"
#import "ProfileLocationTableViewCell.h"
#import "Profile.h"
#import "ProfileLocation.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>
@import GoogleMaps;

@interface ProfileLocationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchLocation;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddLocation;
@property(strong,nonatomic) NSMutableArray* locationInfo;
@property (strong, nonatomic) UITableView* suggestionListView;
@property (strong, nonatomic) GMSPlacesClient* placesClient;
@property (strong, nonatomic) NSMutableArray* places;
@property(strong,nonatomic) NSMutableArray* textFields;
@property(strong,nonatomic)NSMutableArray* profile;
@property(strong,nonatomic)NSMutableArray* location;
@end
static NSString* cellIdentifier = @"ProfileLocationTVC";
@implementation ProfileLocationViewController

-(NSMutableArray*) textFields {
    if (!_textFields) {
        _textFields= [[NSMutableArray alloc] initWithObjects:self.searchLocation, nil];
    }
    return _textFields;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileTableView.dataSource = self;
    self.profileTableView.delegate = self;
    //self.profileTableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.7];
    for (UITextField* textField in self.textFields) {
        [self leftPaddingViewForTextField:textField];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileLocationIsAvailable:) name:@"profileLocationAvailable" object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)profileLocationIsAvailable:(NSNotification*)notification{
    self.locationInfo = ((Profile*)notification.userInfo).locations;
    [self.profileTableView reloadData];
}

#pragma marks location add
- (IBAction)btnAdd:(id)sender {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"token": kStaticToken,
                             @"location": self.searchLocation.text
                             };
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kaddprofileLocation] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        
        NSDictionary *dict=@{@"locationId":@"",
                             @"location": self.searchLocation.text,
                             @"latitude":@"",
                             @"logitude":@""
                             };
        ProfileLocation *profile=[[ProfileLocation alloc]initWithAttributes:dict];
        [self.locationInfo insertObject:profile atIndex:0];
        [self.profileTableView reloadData];
        self.searchLocation.text = @"";
        //Profile* profile = [[NSMutableArray alloc]init];
        //ProfileLocation *location = [[NSMutableArray alloc]init];
        //NSLog(@"profilecount%@",profile.locationCount);
        //[self.locationInfo insertObject:self.searchLocation.text atIndex:0];
        //[self.profileTableView reloadData];
        /*self.locationInfo = [[NSMutableArray alloc]init];
        for(int i = 0; i < [self.locationInfo count]; i++) {
            [self.locationInfo addObject:self.searchLocation.text];
        }
        
        NSLog(@"myArray:\n%@", self.locationInfo);*/
     
        
        //[self.locationInfo insertObject:self.searchLocation.text atIndex:0];
        //[self.profileTableView reloadData];
        //NSLog(@"stte%@",stringToSave);
       /* NSMutableDictionary *paths = self.locationInfo;
        [paths setObject:self.searchLocation.text forKey:@"location"];
        [self.profileTableView reloadData];*/
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"failed");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)btnDelete:(UIButton *)sender {
    if (self.profileTableView) {
        ProfileLocation* locationData = [self.locationInfo objectAtIndex:sender.tag];
        NSLog(@"idtest%@",locationData.locationId);
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{
                                 @"token": kStaticToken,
                                 @"id": locationData.locationId
                                 };
        [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
        [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kdeleteProfileLocation] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.profileTableView];
            NSIndexPath *indexPath = [self.profileTableView indexPathForRowAtPoint:touchPoint];
            [self.locationInfo removeObjectAtIndex:indexPath.row];
            [self.profileTableView reloadData];
            /*[self.locationInfo removeObjectAtIndex:0];
            [self.profileTableView reloadData];
            [self.locationInfo removeObjectAtIndex:sender.tag];
            [self.profileTableView deleteRowsAtIndexPaths:self.locationInfo withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.profileTableView reloadData];*/
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.searchLocation]) {
        [self placeAutocomplete:self.searchLocation.text displayIn:self.view fromView:self.searchLocation];
    }
    return YES;
}


#pragma mark Auto suggest

-(void)setupSuggestionListFromView:(UIView*) fromView addedToTheView:(UIView*) containerView
{
    if(!_suggestionListView)
    {
        CGRect fromFrame= fromView.frame;
        CGRect listFrame= CGRectMake(fromFrame.origin.x, fromFrame.origin.y+fromFrame.size.height+1.0, fromFrame.size.width, fromFrame.size.height * 7);
        _suggestionListView = [[UITableView alloc] initWithFrame:listFrame];
        _suggestionListView.delegate= self;
        _suggestionListView.dataSource= self;
        [_suggestionListView setBackgroundColor:[UIColor clearColor]];
        
        //        _suggestionListView.layer.borderWidth = 1.0;
        //        _suggestionListView.layer.borderColor= [UIColor lightTextColor].CGColor;
        [[_suggestionListView backgroundView] setAlpha:1.0f];
        [_suggestionListView setShowsVerticalScrollIndicator:NO];
        [_suggestionListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [_suggestionListView setBounces:NO];
        [_suggestionListView setUserInteractionEnabled:YES];
        _suggestionListView.hidden= YES;
        _suggestionListView.clipsToBounds= YES;
        [containerView addSubview:_suggestionListView];
        [containerView bringSubviewToFront:_suggestionListView];
    }
}

- (void)placeAutocomplete:(NSString*) forQuery displayIn:(UIView*) view fromView:(UIView*) fromView {
    [self setupSuggestionListFromView:fromView addedToTheView:view];
    _suggestionListView.hidden= YES;
    if (!forQuery.length) {
        return;
    }
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterCity;
    
    _placesClient= [[GMSPlacesClient alloc] init];
    [_placesClient autocompleteQuery:forQuery
                              bounds:nil
                              filter:filter
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    return;
                                }
                                
                                _places= [[NSMutableArray alloc] initWithCapacity:[results count]];
                                for (GMSAutocompletePrediction* result in results) {
                                    [_places addObject:result.attributedFullText.string];
                                }
                                _suggestionListView.hidden= NO;
                                [_suggestionListView reloadData];
                            }];
}


#pragma mark Place Auto Complete

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.profileTableView == tableView){
       return [self.locationInfo count];
    }
    else{
        return [_places count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.profileTableView == tableView){
        ProfileLocationTableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if(!cell){
            cell = [[ProfileLocationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        ProfileLocation* locationData = [self.locationInfo objectAtIndex:indexPath.row];
        cell.location.text = locationData.location;
        cell.btnDelete.tag = indexPath.row;
        return cell;
    }
    else{
        UITableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"SuggestionTVC"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SuggestionTVC"];
        }
        cell.textLabel.text= [_places objectAtIndex:indexPath.row];
        cell.userInteractionEnabled= YES;
        [cell setClipsToBounds:YES];
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor= [UIColor lightTextColor];
    cell.textLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    cell.backgroundColor= [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    for (UIView* view in cell.contentView.subviews) {
        if (view.tag == 1100) {
            [view removeFromSuperview];
        }
    }
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0, cell.frame.size.width - 20.0, 1)];
    separatorLineView.alpha= 0.3;
    separatorLineView.tag= 1100;
    separatorLineView.backgroundColor = [UIColor lightTextColor];//[self defaultColor];
    [cell.contentView addSubview:separatorLineView];
    
    return;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.suggestionListView.hidden= YES;
    self.searchLocation.text= [_places objectAtIndex:indexPath.row];
    
    return;
}
#pragma marks table View
/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.locationInfo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileLocationTableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[ProfileLocationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    ProfileLocation* locationData = [self.locationInfo objectAtIndex:indexPath.row];
    cell.location.text = locationData.location;
}*/
@end
