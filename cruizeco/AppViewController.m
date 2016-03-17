//
//  AppViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 7/4/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "AppViewController.h"
#import <TSMessage.h>

@interface AppViewController ()

@end

@implementation Paginator

-(BOOL) requiresPaging {
    if (self.currentPage < self.pageCount) {
        return YES;
    }
    return NO;
}

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) synchingFailed:(NSString*) message {
    
    if (!message) {
        message= @"There seems to be a problem with network. Please try again";
    }
    [TSMessage showNotificationInViewController:self
                                          title:@"Fitmeet"
                                       subtitle:message
                                          image:nil
                                           type:TSMessageNotificationTypeError
                                       duration:TSMessageNotificationDurationEndless
                                       callback:^{
                                           [TSMessage dismissActiveNotification];
                                       }
                                    buttonTitle:nil
                                 buttonCallback:^{
                                 }
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}


-(void) initiateLocation {
    // Create a location manager
    self.locationManager = [[CLLocationManager alloc] init];
    // Set a delegate to receive location callbacks
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.latitude= [NSString stringWithFormat:@"%.4f", self.locationManager.location.coordinate.latitude];
    self.longitude= [NSString stringWithFormat:@"%.4f", self.locationManager.location.coordinate.longitude];
    
    
    // Start the location manager
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation* location= ((CLLocation*)[locations lastObject]);
    [self.locationManager stopUpdatingLocation];
    
    self.latitude= [NSString stringWithFormat:@"%.4f", location.coordinate.latitude];
    self.longitude= [NSString stringWithFormat:@"%.4f", location.coordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             self.address = [[NSString alloc]initWithString:locatedAt];
             //             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             //             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             //             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@", self.address);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
    if ([self respondsToSelector:@selector(locationIsAvailable)]) {
        [self locationIsAvailable];
    }
    //    [self registerFBUserToAPIWithParameters:self.fbResponse];
}

- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            [self parentLocationIsNotAvailable];
        }
            break;
        case kCLErrorDenied:{
            [self parentLocationIsNotAvailable];
        }
            break;
        default:
            break;
    }
    
    
}

-(void) parentLocationIsNotAvailable {
    if([self respondsToSelector:@selector(locationIsNotAvailable)]) {
        [self locationIsNotAvailable];
    }
}

-(void) leftPaddingViewForTextField:(UITextField*) textField {
    textField.leftView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 20)];
    textField.leftViewMode= UITextFieldViewModeAlways;
    textField.delegate= self;
    
    CGRect frame= textField.frame;
    frame.size.height = 37.0;
    [textField setFrame:frame];
    [textField setBackground:nil];
    [textField.layer setBorderColor:[self defaultColor].CGColor];//[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor];
    [textField.layer setBorderWidth:1.0];
    [textField setBackgroundColor:[UIColor whiteColor]];
//    [textField setBackground:[[UIImage imageNamed:@"longtextField.png"]
//                              resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
}

-(void) rightDropDownViewFor:(UITextField*) textField withImage:(UIImage*) image {
    [self leftPaddingViewForTextField:textField];
    
    UIImage* dropDownImage= image;//[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView* rightDropDown= [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, dropDownImage.size.width, dropDownImage.size.height)];
    rightDropDown.image= dropDownImage;
    [rightDropDown setTintColor:[self defaultColor]];
    
    UIView* rightView= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, dropDownImage.size.width, dropDownImage.size.height)];
    [rightView addSubview:rightDropDown];
    textField.rightView= rightView;
    textField.rightViewMode= UITextFieldViewModeAlways;
//    textField.righ
}

-(UIColor*) defaultColor {
    return [UIColor colorWithRed:18/255.0 green:168/255.0 blue:171/255.0 alpha:1.0];
}

-(UIColor*) secondDefaultColor {
    return [UIColor colorWithRed:243/255.0 green:106/255.0 blue:80/255.0 alpha:1.0];
}


-(NSString*) stringifyDurationFromSeconds:(NSInteger) duration {
    NSString* sentence= @"";
    
    int minutes= duration / 60;
    if (minutes > 0) {
        int hours= minutes / 60;
        int m= minutes % 60;
        sentence= [NSString stringWithFormat:@"%d h %d min",hours, m];
        if (hours > 0) {
            int day= hours / 24;
            if (day > 0) {
                int remainder= hours % 24;
                sentence= [NSString stringWithFormat:@"%d D %d h", day, remainder];
            } else {
                sentence= @"1 D";
            }

        } else {
            sentence= [NSString stringWithFormat:@"%d min", minutes];
        }
    } else {
        sentence= @"1 min";
    }
    return sentence;
}
-(NSString*) kmDistanceFromMeters:(NSInteger) distance {
    float dis= distance;
    return [NSString stringWithFormat:@"%.2f km", (dis/1000)];
}

-(UIView*) tableViewCellSeparator {
    
    UIView* borderView= [[UIView alloc] initWithFrame:CGRectMake(10.0, 45.0, 250, 2.0)];
    borderView.backgroundColor= [UIColor lightGrayColor];
    borderView.alpha= 0.1;
    
    return borderView;
}




@end
