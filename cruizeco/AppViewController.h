//
//  AppViewController.h
//  cruizeco
//
//  Created by Kishor Kundan on 7/4/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface Paginator : NSObject

@property NSInteger currentPage;
@property NSInteger pageCount;
@property BOOL isPaginationInProgress;
-(BOOL) requiresPaging;
@end

@protocol GMPlacesProtocol <NSObject>

-(void) fetchedResults:(NSArray*) results forQuery:(NSString*) searchQuery;
-(void) failedQueryFor:(NSString*) searchQuery error:(NSError*) error;

@end

@interface AppViewController : UIViewController


@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;

@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) id <GMPlacesProtocol> GMPlacesDelegate;

-(void) synchingFailed:(NSString*) message;


-(void) initiateLocation;
-(void) locationIsAvailable;
-(void) locationIsNotAvailable;

-(NSString*) stringifyDurationFromSeconds:(NSInteger) duration;
-(NSString*) kmDistanceFromMeters:(NSInteger) distance;

-(void) leftPaddingViewForTextField:(UITextField*) textField;
-(void) rightDropDownViewFor:(UITextField*) textField withImage:(UIImage*) image;

-(UIView*) tableViewCellSeparator;
-(UIColor*) defaultColor;
-(UIColor*) secondDefaultColor;
@end
