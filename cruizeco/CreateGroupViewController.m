//
//  CreateGroupViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/7/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "CreateGroupViewController.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

#import "CruizeCategory.h"
#import "Cloudinary/Cloudinary.h"
#import "TSMessage.h"
#import "UITextView+Placeholder.h"
@import GoogleMaps;

#import "MembersViewController.h"


enum displayPicker{
    CategoriesPicker,
    TypePicker
} ;


@interface CreateGroupViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewStepFirst;
@property (weak, nonatomic) IBOutlet UIView *viewStepSecond;
@property (weak, nonatomic) IBOutlet UIView *viewStepThird;
@property (weak, nonatomic) IBOutlet UIView *viewBlueLine;


@property (weak, nonatomic) IBOutlet UITextField *textGroupName;
@property (weak, nonatomic) IBOutlet UITextView *textGroupDescription;

@property (weak, nonatomic) IBOutlet UITextField *textGroupLocation;
@property (weak, nonatomic) IBOutlet UITextField *textCategory;
@property (weak, nonatomic) IBOutlet UITextField *textType;
@property (weak, nonatomic) IBOutlet UIButton *btnShowCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnShowTypes;
@property (weak, nonatomic) IBOutlet UIImageView *ivGroupImage;
@property (weak, nonatomic) IBOutlet UIButton *btnGroupImage;


@property (strong, nonatomic) NSMutableArray* textFields;

@property (strong, nonatomic) UIImagePickerController* imagePickerController;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarDone;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarCancel;

@property (strong, nonatomic) NSMutableArray* categories;
@property (strong, nonatomic) NSArray* types;

@property (strong, nonatomic) NSString* categoryId;
@property (strong, nonatomic) NSString* typeId;

@property (strong, nonatomic) NSString* cancelCategoryText;
@property (strong, nonatomic) NSString* cancelTypeText;

@property NSInteger displayPickerFor;

@property (strong, nonatomic) CLCloudinary *cloudinary;
@property (strong, nonatomic) NSString* groupImage;


@property NSInteger pictureUploadRetry;
@property BOOL pictureUploadInProgress;



@property (strong, nonatomic) UITableView* suggestionListView;
@property (strong, nonatomic) GMSPlacesClient* placesClient;
@property (strong, nonatomic) NSMutableArray* places;



@property NSInteger networkRetries;
@end

@implementation CreateGroupViewController

-(CLCloudinary*) cloudinary {
    if (!_cloudinary) {
        _cloudinary = [[CLCloudinary alloc] initWithUrl: @"cloudinary://255386675549718:1BGsHwwedJqjvqmXEeA5avqJxU8@one-platinum-technologies-pvt-ltd"];
        
        [_cloudinary.config setValue:@"one-platinum-technologies-pvt-ltd" forKey:@"cloud_name"];
        [_cloudinary.config setValue:@"255386675549718" forKey:@"api_key"];
        [_cloudinary.config setValue:@"1BGsHwwedJqjvqmXEeA5avqJxU8" forKey:@"api_secret"];
    }
    return _cloudinary;
}

-(NSMutableArray*) textFields {
    if (!_textFields) {
        _textFields= [[NSMutableArray alloc] initWithObjects:self.textGroupName/*, self.textGroupDescription*/, self.textGroupLocation, self.textCategory, self.textType, nil];
    }
    return _textFields;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    for (UITextField* textField in self.textFields) {
        [self leftPaddingViewForTextField:textField];
    }
    [self.textGroupDescription setPlaceholder:@"Group description"];
    [self.textGroupDescription.layer setBorderColor:[self defaultColor].CGColor];//[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 step:1.0].CGColor];
    [self.textGroupDescription.layer setBorderWidth:1.0];
    [self.textGroupDescription setBackgroundColor:[UIColor whiteColor]];
    [self getInfosForCategoryAndType];
    self.types= [NSArray arrayWithObjects:@"Public", @"Private", @"Public with invite", nil];
}


-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title= @"Create Group (step 1 of 2)";
    
//    [self setupUI];
    
}

-(void) viewDidLayoutSubviews {
    [self setupUI];
}

-(void) setupUI {
    self.viewStepFirst.layer.cornerRadius= CGRectGetHeight(self.viewStepFirst.frame)/2.0;
    self.viewStepFirst.layer.masksToBounds= YES;
    [self.viewStepFirst setNeedsDisplay];
    
    [self.viewStepSecond layoutIfNeeded];
    self.viewStepSecond.layer.cornerRadius= CGRectGetHeight(self.viewStepSecond.frame)/2.0;
    self.viewStepSecond.clipsToBounds= YES;
    
    [self.viewStepThird layoutIfNeeded];
    self.viewStepThird.layer.cornerRadius= CGRectGetHeight(self.viewStepThird.frame)/2.0;
    self.viewStepThird.clipsToBounds= YES;
    
    self.viewBlueLine.layer.cornerRadius= CGRectGetHeight(self.viewBlueLine.frame)/2.0;
    self.viewBlueLine.clipsToBounds= YES;
    
    NSInteger index= 0;
    for (UIView* viewStep in [NSArray arrayWithObjects:self.viewStepFirst,self.viewStepSecond, self.viewStepThird, nil]) {
        
        for (id subview in viewStep.subviews) {
            if ([subview isKindOfClass:[UIView class]]) {
                UIView* coloredStepView= subview;
                coloredStepView.layer.cornerRadius= CGRectGetHeight(coloredStepView.frame)/2.0;
                coloredStepView.clipsToBounds= YES;
                if (index > 1) {
                    coloredStepView.alpha= 0.4;
                }
                index++;
            }
        }
    }
    UIBarButtonItem *dropDown = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"check_nav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(createGroup:)];
    dropDown.tintColor= [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem= dropDown;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void) getInfosForCategoryAndType {
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken};
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kGenericList] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        self.categories= [[NSMutableArray alloc] init];
        for (NSDictionary* cCategory in [[[responseObject objectForKey:@"output"] objectForKey:@"response"] objectForKey:@"Category"]) {
           
            [self.categories addObject:[[CruizeCategory alloc] initWithAttributes:cCategory]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)showCategories:(UIButton*)sender {
    self.displayPickerFor= CategoriesPicker;
    self.pickerView.delegate= self;
    self.pickerView.dataSource= self;
    self.cancelCategoryText= self.textCategory.text;
    [self hideToolBarAndPicker:NO];
}

- (IBAction)showTypes:(UIButton*)sender {
    self.displayPickerFor= TypePicker;
    self.pickerView.delegate= self;
    self.pickerView.dataSource= self;
    self.cancelTypeText= self.textType.text;
    [self hideToolBarAndPicker:NO];
}

- (IBAction)selectImage:(id)sender {
    [self selectImageSource];
}

#pragma mark Profile Picture
-(void) selectImageSource {
    // AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Photo Library",@"Camera", nil];
    //    if (ad.me.hasFacebook) {
    //        [actionSheet addButtonWithTitle:@"FB profile picture"];
    //    }
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        switch (buttonIndex) {
            case 0:
                [self takePicture:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            case 1:
                [self takePicture:UIImagePickerControllerSourceTypeCamera];
                break;
            case 3: {
                //AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                //                    https://graph.facebook.com/10156354238620508/picture?type=large
                //                self.profilePic= [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", ad.me.f]
                //    self.profilePicture
            }
                break;
        }
    }
}



-(void) takePicture:(UIImagePickerControllerSourceType) source {
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        [self.imagePickerController setSourceType:source];
        [self.imagePickerController setDelegate:self];
        self.imagePickerController.navigationBar.barTintColor= [self defaultColor];
        self.imagePickerController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:NSForegroundColorAttributeName forKey:[UIColor whiteColor]];
        
        //  @[
        //                                                  NSForegroundColorAttributeName : UIColor.whiteColor()
        //                                                  ];
        self.imagePickerController.navigationBar.tintColor= [UIColor whiteColor];
    }
    // [self.navigationController pushViewController:self.imagePickerController animated:YES];
    
    self.navigationItem.title= @"";
    self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.ivGroupImage setImage:img];
    [self uploadGroupImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



-(void) uploadGroupImage {
    self.pictureUploadInProgress= YES;
    
    NSData* imageData= UIImagePNGRepresentation(self.ivGroupImage.image);
    
    CLUploader* uploader = [[CLUploader alloc] init:self.cloudinary delegate:nil];
    [uploader upload:imageData options:@{} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
        if (successResult) {
            NSString* publicId = [successResult valueForKey:@"public_id"];
            self.groupImage= [successResult valueForKey:@"secure_url"];
            self.pictureUploadInProgress= NO;
        } else {
            if (self.pictureUploadRetry < 3) {
                self.pictureUploadRetry++;
                [self uploadGroupImage];
            } else {
                self.pictureUploadRetry= 0;
                self.pictureUploadInProgress= NO;
                [TSMessage showNotificationInViewController:self title:@"Cruizeco" subtitle:@"Image could not be uploaded. Tap here to retry again. You can also change the image later." image:nil type:TSMessageNotificationTypeWarning duration:5.0 callback:^{
                    [TSMessage dismissActiveNotification];
                    [self uploadGroupImage];
                } buttonTitle:nil buttonCallback:^{
                    [TSMessage dismissActiveNotification];
                    [self uploadGroupImage];
                } atPosition:TSMessageNotificationPositionTop canBeDismissedByUser:YES];
            }
            
        }
    } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
        
        NSString* profilePicture= [NSString stringWithFormat:@"Picture being uploaded (%ld%%)", ((totalBytesWritten/ totalBytesExpectedToWrite)*100)];
    }];
}

- (IBAction)cancelToolbar:(id)sender {
    [self hideToolBarAndPicker:YES];
    switch (self.displayPickerFor) {
        case CategoriesPicker: {
            self.textCategory.text= self.cancelCategoryText;
        }
            break;
        case TypePicker: {
            self.textType.text= self.cancelTypeText;
        }
            break;
        default:
            break;
    }
}

- (IBAction)doneToolbar:(id)sender {
    [self hideToolBarAndPicker:YES];
    switch (self.displayPickerFor) {
        case CategoriesPicker: {
            self.cancelCategoryText= self.textCategory.text;
        }
            break;
        case TypePicker: {
            self.cancelTypeText= self.textType.text;
        }
            break;
        default:
            break;
    }
}

-(void) hideToolBarAndPicker:(BOOL) hide {
    [self.toolBar setHidden:hide];
    [self.pickerView setHidden:hide];
}

#pragma mark UIPickerView Delegates


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rows= 0;
    switch (self.displayPickerFor) {
        case CategoriesPicker:
            rows= [self.categories count];
            break;
        case TypePicker:
            rows= [self.types count];
            break;
        default:
            break;
    }
    return rows;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString* title;
    switch (self.displayPickerFor) {
        case CategoriesPicker:
            title= ((CruizeCategory*)[self.categories objectAtIndex:row]).title;
            break;
        case TypePicker:
            title= [self.types objectAtIndex:row];
            break;
        default:
            break;
    }
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.displayPickerFor) {
        case CategoriesPicker: {
            self.textCategory.text= ((CruizeCategory*)[self.categories objectAtIndex:row]).title;
            self.categoryId= ((CruizeCategory*)[self.categories objectAtIndex:row]).ID;
        }
            break;
        case TypePicker: {
            self.textType.text= [self.types objectAtIndex:row];
            self.typeId= [NSString stringWithFormat:@"%ld", (row+1)];
        }
            break;
        default:
            break;
    }
}

-(BOOL) validation {
    if (!self.categoryId.length || !self.typeId.length || !self.textGroupName.text.length || !self.textGroupDescription.text.length || !self.textGroupLocation.text.length) {
        return NO;
    }
    return YES;
}

-(void) createGroup:(UIBarButtonItem*) sender {
    
    if (self.pictureUploadInProgress) {
        [TSMessage showNotificationInViewController:self title:@"Cruizeco" subtitle:@"Group image is being uploaded. Please wait." type:TSMessageNotificationTypeMessage duration:5.0 canBeDismissedByUser:YES];
        return;
    }
    if (!self.groupImage) {
        self.groupImage= @"";
    }
    if (![self validation]) {
        [TSMessage showNotificationWithTitle:@"Cruizeco" subtitle:@"All fields are required. You can update the image later" type:TSMessageNotificationTypeWarning];
        return;
    }
    
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"token": kStaticToken,
                             @"category_id": self.categoryId,
                             @"name": self.textGroupName.text,
                             @"descp": self.textGroupDescription.text,
                             @"image": self.groupImage,
                             @"location": self.textGroupLocation.text,
                             @"type_id": self.typeId
                             };
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kCreateGroup] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            if (self.networkRetries < 3) {
                self.networkRetries++;
                [self createGroup:sender];
                return ;
            }
            return;
        }
        self.networkRetries= 0;
        MembersViewController* membersVC= [self.storyboard instantiateViewControllerWithIdentifier:@"MembersVC"];
        membersVC.isSelectionForGroup= YES;
        membersVC.groupId= [[responseObject objectForKey:@"output"] objectForKey:@"response"];
        membersVC.title= @"Add Members (Step 2 of 2)";
        self.navigationItem.title= @"";
        [self.navigationController pushViewController:membersVC animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.networkRetries < 3) {
            self.networkRetries++;
            [self createGroup:sender];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.textGroupLocation]) {
        [self placeAutocomplete:self.textGroupLocation.text displayIn:self.view fromView:self.textGroupLocation];
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
    return [_places count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"SuggestionTVC"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SuggestionTVC"];
    }
    cell.textLabel.text= [_places objectAtIndex:indexPath.row];
    cell.userInteractionEnabled= YES;
    [cell setClipsToBounds:YES];
    return cell;
    
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
    _suggestionListView.hidden= YES;
    self.textGroupLocation.text= [_places objectAtIndex:indexPath.row];
    return;
}



@end
