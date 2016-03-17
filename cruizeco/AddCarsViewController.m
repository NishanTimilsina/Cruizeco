//
//  AddCarsViewController.m
//  cruizeco
//
//  Created by One Platinum on 1/14/16.
//  Copyright © 2016 Kishor Kundan. All rights reserved.
//

#import "AddCarsViewController.h"
/*By rabi*/
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>
#import "Cloudinary/Cloudinary.h"
#import "MoreCarsCollectionViewCell.h"
#import "TSMessage.h"
#import "CarMake.h"
#import "CarModel.h"
#import "CarEngineType.h"
#import "CarFuelType.h"

enum displayPicker{
    MakePicker,
    ModelPicker,
    EngineTypePicker,
    FuelTypePicker
};
@interface AddCarsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtMake;
@property (weak, nonatomic) IBOutlet UIButton *btnMake;
@property (weak, nonatomic) IBOutlet UITextField *txtModel;
@property (weak, nonatomic) IBOutlet UIButton *btnModel;
@property (weak, nonatomic) IBOutlet UITextField *txtEngine;

@property (weak, nonatomic) IBOutlet UIButton *btnEngine;
@property (weak, nonatomic) IBOutlet UITextField *txtFuelType;
@property (weak, nonatomic) IBOutlet UIButton *btnFuelType;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UITextField *txtModification;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (weak, nonatomic) IBOutlet UICollectionView *addMoreCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *btnAddVehicle;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarDone;
@property NSInteger displayPickerFor;


@property (strong, nonatomic) CarMake* activeCarMake;
@property (strong,nonatomic) NSMutableArray * make;
@property (strong,nonatomic)NSMutableArray* models;
@property(strong,nonatomic)NSMutableArray*engineType;
@property(strong,nonatomic)NSMutableArray*fuelType;

@property (strong,nonatomic) NSString * makeId;
@property (strong,nonatomic)NSString*modelId;
@property(strong,nonatomic)NSString*engineTypeId;
@property(strong,nonatomic)NSString*fuelTypeId;

@property (strong,nonatomic) NSString * cancelMakeText;
@property (strong,nonatomic)NSString* cancelModelText;
@property(strong,nonatomic)NSString* cancelEngineTypeText;
@property(strong,nonatomic)NSString* cancelFuelTypeText;
@property (strong,nonatomic)UIImagePickerController * imagePickerController;
@property(strong,nonatomic) CLCloudinary *cloudinary;
@property(strong,nonatomic)NSMutableArray* carsImages;
@property NSInteger pictureUploadRetry;

@property BOOL pictureUploadInProgress;
@end

@implementation AddCarsViewController
-(CLCloudinary*) cloudinary {
    if (!_cloudinary) {
        _cloudinary = [[CLCloudinary alloc] initWithUrl: @"cloudinary://255386675549718:1BGsHwwedJqjvqmXEeA5avqJxU8@one-platinum-technologies-pvt-ltd"];
        
        [_cloudinary.config setValue:@"one-platinum-technologies-pvt-ltd" forKey:@"cloud_name"];
        [_cloudinary.config setValue:@"255386675549718" forKey:@"api_key"];
        [_cloudinary.config setValue:@"1BGsHwwedJqjvqmXEeA5avqJxU8" forKey:@"api_secret"];
    }
    return _cloudinary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self getMakeModelEngineTypeAndFuelType];
    self.addMoreCollectionView.delegate= self;
    self.addMoreCollectionView.dataSource= self;
    self.carsImages= [[NSMutableArray alloc] init];
    
}
-(void)setupUI{
    self.txtMake.layer.borderWidth = 1.0;
    self.txtMake.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(156/255.0) blue:(158/255.0) alpha:1].CGColor;
    self.txtModel.layer.borderWidth = 1.0;
    self.txtModel.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(156/255.0) blue:(158/255.0) alpha:1].CGColor;
    self.txtEngine.layer.borderWidth = 1.0;
    self.txtEngine.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(156/255.0) blue:(158/255.0) alpha:1].CGColor;
    self.txtFuelType.layer.borderWidth = 1.0;
    self.txtFuelType.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(156/255.0) blue:(158/255.0) alpha:1].CGColor;
    self.txtYear.layer.borderWidth = 1.0;
    self.txtYear.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(156/255.0) blue:(158/255.0) alpha:1].CGColor;
    self.txtModification.layer.borderWidth = 1.0;
    self.txtModification.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(156/255.0) blue:(158/255.0) alpha:1].CGColor;
    self.txtDescription.layer.borderWidth = 1.0;
    self.txtDescription.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(156/255.0) blue:(158/255.0) alpha:1].CGColor;
    self.btnAddVehicle.layer.borderWidth = 1.0;
    
    self.btnAddVehicle.layer.cornerRadius = 5.0;
    self.btnAddVehicle.layer.borderColor = [UIColor colorWithRed:(243/255.0) green:(106/255.0) blue:(80/255.0) alpha:1].CGColor;
    self.btnAddVehicle.clipsToBounds = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark API Calls
-(void)getMakeModelEngineTypeAndFuelType{
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken};
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@",kBaseUrl,kGenericList] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"test%@",responseObject);
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        self.make = [[NSMutableArray alloc] init];
        for (NSDictionary* makeDictionary in [[[responseObject objectForKey:@"output"] objectForKey:@"response"] objectForKey:@"Make"]){
            [self.make addObject:[[CarMake alloc]initWithAttributes:makeDictionary]];
        }
        
        
        self.models = [[NSMutableArray alloc] init];
        for (NSDictionary* modelDictionary in [[[responseObject objectForKey:@"output"] objectForKey:@"response"] objectForKey:@"Modal"]){
            
            CarModel* modelCar= [[CarModel alloc] initWithAttributes:modelDictionary];
            
            for (CarMake* carMake in self.make) {
                if ([carMake.ID isEqualToString:modelCar.makeId]) {
                    [carMake.models addObject:modelCar];
                }
            }
            [self.models addObject:[[CarModel alloc] initWithAttributes:modelDictionary]];
        }
        
        self.engineType = [[NSMutableArray alloc] init];
        for (NSDictionary* engineTypeDictionary in [[[responseObject objectForKey:@"output"] objectForKey:@"response"] objectForKey:@"EngineType"]){
            [self.engineType addObject:[[CarEngineType alloc]initWithAttributes:engineTypeDictionary]];
        }
        
        self.fuelType = [[NSMutableArray alloc] init];
        for (NSDictionary* fuelTypeDictionary in [[[responseObject objectForKey:@"output"] objectForKey:@"response"] objectForKey:@"FuelType"]){
            [self.fuelType addObject:[[CarFuelType alloc]initWithAttributes:fuelTypeDictionary]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)showMake:(UIButton*)sender {
    self.displayPickerFor = MakePicker;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.cancelMakeText = self.txtMake.text;
    [self hideToolBarAndPicker:NO];
}
- (IBAction)showModel:(id)sender {
    self.displayPickerFor = ModelPicker;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.cancelModelText = self.txtModel.text;
    [self hideToolBarAndPicker:NO];
}
- (IBAction)showEngineType:(id)sender {
    self.displayPickerFor = EngineTypePicker;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.cancelModelText = self.txtEngine.text;
    [self hideToolBarAndPicker:NO];
}

- (IBAction)showFuelType:(id)sender {
    self.displayPickerFor = FuelTypePicker;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.cancelFuelTypeText = self.txtFuelType.text;
    [self hideToolBarAndPicker:NO];
}

- (IBAction)toolBarCancel:(id)sender {
    [self hideToolBarAndPicker:YES];
    switch (self.displayPickerFor) {
        case MakePicker:{
            self.txtMake.text = self.cancelMakeText;
         }
            break;
        case ModelPicker:{
            self.txtModel.text = self.cancelModelText;
        }
            break;
        case EngineTypePicker:{
            self.txtEngine.text = self.cancelEngineTypeText;
        }
            break;
        case FuelTypePicker:{
            self.txtFuelType.text = self.cancelFuelTypeText;
        }
            break;
        default:
            break;
    }
}
- (IBAction)toolBarDone:(id)sender {
    
    [self hideToolBarAndPicker:YES];
    switch (self.displayPickerFor) {
        case MakePicker:{
            self.cancelMakeText =self.txtMake.text;
        }
            break;
        case ModelPicker:{
            self.cancelModelText = self.txtModel.text;
        }
            break;
        case EngineTypePicker:{
            self.cancelEngineTypeText = self.txtEngine.text;
        }
            break;
        case FuelTypePicker:{
            self.cancelFuelTypeText = self.txtFuelType.text;
        }
            break;
        default:
            break;
    }

}
-(void)hideToolBarAndPicker:(BOOL) hide{
    [self.toolBar setHidden:hide];
    [self.pickerView setHidden:hide];
}
- (IBAction)btnAddMoreCars:(id)sender {
    [self selectImageSource];
}

- (IBAction)btnAddCars:(UIButton*)sender {
    NSLog(@"image test%@",self.carsImages);
   AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{
                                 @"token": kStaticToken,
                                 @"make_id": self.makeId,
                                 @"modal_id":self.modelId,
                                 @"engine_type_id":self.engineTypeId,
                                 @"fuel_type_id":self.fuelTypeId,
                                 @"year":self.txtYear.text,
                                 @"descp":self.txtDescription.text,
                                 @"modification":self.txtModification.text,
                                 //@"image":@"http://res.cloudinary.com/oneplatinumtechnology/image/upload/v1454234022/c0ztvo312nqqira86cfl.png"
                                 @"image":self.carsImages
                                 };
    //NSLog(@"param%@",params);
        [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
        [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kaddVehicle] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseresult%@",responseObject);
            if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                return;
            }
            NSLog(@"success");
            
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"failed");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
}

#pragma marks add cars image
-(void)selectImageSource{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Photo library",@"Camera", nil
                                  ];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        switch (buttonIndex) {
            case 0:
                [self takePicture:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            case 1:
                [self takePicture:UIImagePickerControllerSourceTypeCamera];
                break;
            default:
                break;
        }
    }
}
-(void)takePicture:(UIImagePickerControllerSourceType)source{
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    //UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.carsImages addObject:image];
    [self uploadCarImages];
    [self.addMoreCollectionView reloadData];
}
-(void) uploadCarImages {
    self.pictureUploadInProgress= YES;
    CLUploader* uploader = [[CLUploader alloc] init:self.cloudinary delegate:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:@"addImage.png"];
    CLTransformation *transformation = [CLTransformation transformation];
    [transformation setParams: @{@"width": @800, @"height": @600, @"crop": @"limit"}];
    
    [uploader upload:imageData options:@{@"transformation": transformation}];
   /* NSLog(@"upload image");
    /*NSMutableData* myData = [NSKeyedArchiver archivedDataWithRootObject:self.carsImages];*/
    //NSLog(@"arraytest%@",myData);
    /*NSMutableArray *arrImgData = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.carsImages count];  i++)
    {
        NSData *imageData = UIImageJPEGRepresentation([self.carsImages objectAtIndex:i], 0.8);
        [arrImgData insertObject:imageData atIndex:i];
        }
    */
    //NSMutableData *body = [NSMutableData data];
    //NSMutableData* imageData= UIImagePNGRepresentation(self.carsImages);
    /*NSMutableData* test = [[NSMutableData alloc]init];
    CLUploader* uploader = [[CLUploader alloc] init:self.cloudinary delegate:nil];
    [uploader upload:test options:@{} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
        if (successResult) {
            NSLog(@"a");
            NSString* publicId = [successResult valueForKey:@"public_id"];
            self.carsImages= [successResult valueForKey:@"secure_url"];
            self.pictureUploadInProgress= NO;
        } else {
            if (self.pictureUploadRetry < 3) {
                NSLog(@"a1");
                self.pictureUploadRetry++;
                [self uploadCarImages];
            } else {
                NSLog(@"a2");
                self.pictureUploadRetry= 0;
                self.pictureUploadInProgress= NO;
                [TSMessage showNotificationInViewController:self title:@"Cruizeco" subtitle:@"Image could not be uploaded. Tap here to retry again. You can also change the image later." image:nil type:TSMessageNotificationTypeWarning duration:5.0 callback:^{
                    [TSMessage dismissActiveNotification];
                    [self uploadCarImages];
                } buttonTitle:nil buttonCallback:^{
                    NSLog(@"a3");
                    [TSMessage dismissActiveNotification];
                    [self uploadCarImages];
                } atPosition:TSMessageNotificationPositionTop canBeDismissedByUser:YES];
            }
            
        }
    } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
        
        NSString* profilePicture= [NSString stringWithFormat:@"Picture being uploaded (%ld%%)", ((totalBytesWritten/ totalBytesExpectedToWrite)*100)];
    }];*/
}
/*-(void)uploadCarImages{
    self.pictureUploadInProgress = YES;
    NSLog(@"images%@",self.carsImages);
    NSData* imageData= UIImagePNGRepresentation(self.carsImages);
     CLUploader* uploader = [[CLUploader alloc] init:self.cloudinary delegate:nil];
    [uploader upload:imageData options:@{} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context)
    {
        if (successResult) {
            NSString* publicId = [successResult valueForKey:@"public_id"];
            self.carsImages= [successResult valueForKey:@"secure_url"];
            self.pictureUploadInProgress= NO;
        } else
        {
            if (self.pictureUploadRetry < 3) {
                self.pictureUploadRetry++;
                [self uploadCarImages];
            } else {
                self.pictureUploadRetry= 0;
                self.pictureUploadInProgress= NO;
                [TSMessage showNotificationInViewController:self title:@"Cruizeco" subtitle:@"Image could not be uploaded. Tap here to retry again. You can also change the image later." image:nil type:TSMessageNotificationTypeWarning duration:5.0 callback:^{
                    [TSMessage dismissActiveNotification];
                    [self uploadCarImages];
                } buttonTitle:nil buttonCallback:^{
                    [TSMessage dismissActiveNotification];
                    [self uploadCarImages];
                } atPosition:TSMessageNotificationPositionTop canBeDismissedByUser:YES];
        }
        
        
    }
    
}*/
#pragma marks collection view 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   // NSLog(@"counts %lu ", (unsigned long)self.carsImages.count);
    return [self.carsImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoreCarsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreCarsCVC" forIndexPath:indexPath];
    [cell.ivMoreCar setImage:[self.carsImages objectAtIndex:indexPath.row]];
    [cell setBackgroundColor:[UIColor redColor]];
    return cell;
}
#pragma mark ui picker deligate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger rows = 0;
    switch (self.displayPickerFor) {
        case MakePicker:
            rows = [self.make count];
            break;
        case ModelPicker:
            rows= [self.activeCarMake.models count];
            break;
        case EngineTypePicker:
            rows = [self.engineType count];
            break;
        case FuelTypePicker:
            rows = [self.fuelType count];
            break;
        default:
        break;
    }
    return rows;
}
-(nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* title;
    switch (self.displayPickerFor) {
        case MakePicker:
            title = ((CarMake*)[self.make objectAtIndex:row]).title;
            break;
         case ModelPicker:
            title = ((CarModel*)[self.activeCarMake.models objectAtIndex:row]).title;
            break;
        case EngineTypePicker:
            title = ((CarEngineType*)[self.engineType objectAtIndex:row]).enginetypeTitle;
            break;
            case FuelTypePicker:
            title = ((CarFuelType*)[self.fuelType objectAtIndex:row]).fuelTypeTitle;
            break;
        default:
            break;
    }
    return title;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (self.displayPickerFor) {
        case MakePicker:
            self.txtMake.text = ((CarMake*)[self.make objectAtIndex:row]).title;
            self.makeId = ((CarMake*)[self.make objectAtIndex:row]).ID;
            self.activeCarMake= ((CarMake*)[self.make objectAtIndex:row]);
            break;
         case ModelPicker:
            self.txtModel.text = ((CarModel*)[self.activeCarMake.models objectAtIndex:row]).title;
            self.modelId = ((CarModel*)[self.activeCarMake.models objectAtIndex:row]).modelId;
            break;
        case EngineTypePicker:
            self.txtEngine.text = ((CarEngineType*)[self.engineType objectAtIndex:row]).enginetypeTitle;
            self.engineTypeId = ((CarEngineType*)[self.engineType objectAtIndex:row]).engineTypeId;
            break;
        case FuelTypePicker:
            self.txtFuelType.text = ((CarFuelType*)[self.fuelType objectAtIndex:row]).fuelTypeTitle;
            self.fuelTypeId = ((CarFuelType*)[self.fuelType objectAtIndex:row]).fuelTypeId;
            break;
        default:
            break;
    }
}

@end
