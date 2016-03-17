//
//  CreateTrackViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/2/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "CreateTrackViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "JMActionSheet.h"
#import "UIButton+Block.h"
#import <SMCalloutView/SMCalloutView.h>



#import <AFNetworking/AFHTTPRequestOperationManager.h>

#import "Popup.h"

#import "GMRoute.h"
#import "TrackInfo.h"

static const CGFloat CalloutYOffset = 0.0f;//35.0f;

@interface CreateTrackViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) GMSPlacesClient* placesClient;

@property CLLocationCoordinate2D activeAnchor;

@property (strong, nonatomic) UIView *emptyCalloutView;
@property (strong, nonatomic) SMCalloutView *calloutView;

@property (strong, nonatomic) NSMutableArray* placesIds;

@property (strong, nonatomic) NSMutableArray* routes;

@property NSInteger activeWaypoint;
@property (weak, nonatomic) IBOutlet UILabel *labelWayPoint;
@property (weak, nonatomic) IBOutlet UILabel *labelWaypointValue;
@property (weak, nonatomic) IBOutlet UILabel *labelTrack;
@property (weak, nonatomic) IBOutlet UILabel *labelTrackValue;

@property (strong, nonatomic) NSString* trackDistance;
@property (strong, nonatomic) NSString* trackDuration;
@property (strong, nonatomic) NSString* waypointDistance;
@property (strong, nonatomic) NSString* waypointDuration;

@property BOOL isMetricLabelsVisible;
@property (weak, nonatomic) IBOutlet UIButton *btnCar;
@property (weak, nonatomic) IBOutlet UIButton *btnCycle;
@property (weak, nonatomic) IBOutlet UIButton *btnTransit;
@property (weak, nonatomic) IBOutlet UIButton *btnWalk;

@property (strong, nonatomic) NSString* travelMode;

@property BOOL calloutForMarker;
@property (strong, nonatomic) GMSMarker* activeMarker;

@property (strong, nonatomic) NSMutableArray* markers;

@property (strong, nonatomic) UIButton* rightAccessoryButton;

@end

@implementation CreateTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.placesIds= [[NSMutableArray alloc] init];
    self.routes= [[NSMutableArray alloc] init];
    self.calloutView = [[SMCalloutView alloc] init];
    
    
    
    
    self.rightAccessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];;//[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [self.rightAccessoryButton setImage:[UIImage imageNamed:@"marker-edit.png"] forState:UIControlStateNormal];
    [self.rightAccessoryButton addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
//    self.calloutView.rightAccessoryView = self.rightAccessoryButton;
    [self.btnCar setSelected:YES];
}

- (void)calloutAccessoryButtonTapped:(id)sender {
    if (self.mapView.selectedMarker) {
        GMSMarker *marker = self.mapView.selectedMarker;
        MarkerInfo* markerInfo= marker.userData;
        [self showPopup:markerInfo.title subtitle:markerInfo.markerDescription type:markerInfo.type];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    self.mapView.delegate= self;
    [self initiateLocation];
//    [self titleAndSubtitleForMarker:nil forType:@"Cafe"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) locationIsAvailable {
    CLLocationCoordinate2D target= CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    self.mapView.settings.myLocationButton= YES;
    self.mapView.settings.compassButton= YES;
    [self.mapView animateToLocation:target];
    [self.mapView animateToZoom:12];
    self.mapView.myLocationEnabled= YES;
}

-(void) locationIsNotAvailable {

}

#pragma mark Google Maps
- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    CGPoint point = [mapView.projection pointForCoordinate:coordinate];
    self.calloutForMarker= NO;
    self.activeAnchor= coordinate;
    self.calloutView.contentView= [self mapView:self.mapView needsSelectionAtLocation:coordinate];
    self.calloutView.rightAccessoryView= nil;
    self.calloutView.calloutOffset = CGPointMake(0, 0); //-CalloutYOffset);
    
    self.calloutView.hidden = NO;

    CGRect calloutRect = CGRectZero;
    calloutRect.origin = point;
    calloutRect.size = CGSizeZero;
    [self.calloutView presentCalloutFromRect:calloutRect
                                      inView:mapView
                           constrainedToView:mapView
                                    animated:YES];
}


- (void)mapView:(GMSMapView *)pMapView didChangeCameraPosition:(GMSCameraPosition *)position {
    /* move callout with map drag */
    if (!self.calloutView.hidden) {
        CLLocationCoordinate2D anchor = self.activeAnchor;
        
        CGPoint arrowPt = self.calloutView.backgroundView.arrowPoint;
        
        CGPoint pt = [pMapView.projection pointForCoordinate:anchor];
        pt.x -= arrowPt.x;
        pt.y -= arrowPt.y;// + CalloutYOffset;
        if (self.calloutForMarker) {
            pt.y += CalloutYOffset;
        }
        
        self.calloutView.frame = (CGRect) {.origin = pt, .size = self.calloutView.frame.size };
    } else {
        self.calloutView.hidden = YES;
    }
}



- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    /* don't move map camera to center marker on tap */
    mapView.selectedMarker = marker;
    self.calloutForMarker= YES;
    return YES;
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    CLLocationCoordinate2D anchor = marker.position;
    
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    
    MarkerInfo* markerInfo= marker.userData;
    self.calloutView.contentView= nil;
    self.calloutView.title = markerInfo.title;
    self.calloutView.subtitle= markerInfo.markerDescription;
    self.calloutView.rightAccessoryView= self.rightAccessoryButton;
    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
    
    self.calloutView.hidden = NO;
    
    CGRect calloutRect = CGRectZero;
    calloutRect.origin = point;
    calloutRect.size = CGSizeZero;
    
    [self.calloutView presentCalloutFromRect:calloutRect
                                      inView:mapView
                           constrainedToView:mapView
                                    animated:YES];
    

    return self.emptyCalloutView;
}

#pragma mark UI for values
-(void) showHideLabelsForDistanceAndDuration:(BOOL) show {
    self.isMetricLabelsVisible= show;
    show= !show;
    self.labelTrack.hidden= show;
    self.labelTrackValue.hidden= show;
    self.labelWayPoint.hidden= show;
    self.labelWaypointValue.hidden= show;
}

-(void) updateTrackDistance:(NSString*) trackDistance trackDuration:(NSString*) trackDuration waypointDistance:(NSString*) waypointDistance andWaypointDuration:(NSString*) waypointDuration {
    if (!self.isMetricLabelsVisible) {
        self.isMetricLabelsVisible= YES;
        [self showHideLabelsForDistanceAndDuration:YES];
    }
    self.labelTrackValue.text= [NSString stringWithFormat:@"%@ | %@", trackDistance, trackDuration];
    self.labelWaypointValue.text= [NSString stringWithFormat:@"%@ | %@", waypointDistance, waypointDuration];
}

- (IBAction)updateTravelModel:(UIButton*)sender {
    [self.btnCar setSelected:NO];
    [self.btnCycle setSelected:NO];
    [self.btnTransit setSelected:NO];
    [self.btnWalk setSelected:NO];
    
    [sender setSelected:YES];
    
    switch (sender.tag) {
        case 1001:
            self.travelMode= @"driving";
            break;
        case 1002:
            self.travelMode= @"bicycling";
            break;
        case 1003:
            self.travelMode= @"transit";
            break;
        case 1004:
            self.travelMode= @"walking";
            break;
        default:
            break;
    }
}


-(UIView*) mapView:(GMSMapView*) mapView needsSelectionAtLocation:(CLLocationCoordinate2D) location {
    NSArray* buttons= [NSArray arrayWithObjects:@"Cafe", @"Stops", @"Landmark", @"Waypoint", @"Cancel", nil];
    
    CGPoint origin= CGPointMake(0.0, 0.0);
    CGSize size= CGSizeMake(95.0, 35.0);
    
    UIView* selectionView= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height * [buttons count])];
    [selectionView setBackgroundColor:[UIColor clearColor]];
    
    int i= 0;
    for (NSString* title in buttons) {
        UIButton* button= [[UIButton alloc] initWithFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
        [button setTitle:title forState:UIControlStateNormal];
        if (i < 3) {
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        } else if (i ==3) {
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
        } else {
            [button setTitleColor:[self secondDefaultColor] forState:UIControlStateNormal];
        }
        
        [button setBackgroundColor:[UIColor clearColor]];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        [button setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
            [self mapView:self.mapView dropped:title atLocation:location];
        }];
        
        if (i < 4) {
            UIView* border= [[UIView alloc] initWithFrame:CGRectMake(origin.x + 1.0, size.height+ origin.y, size.width- 2.0, 1.0)];
            [border setBackgroundColor:[UIColor lightGrayColor]];
            [border setAlpha:0.1];
            [selectionView addSubview:border];
        }
        
        [selectionView addSubview:button];
        origin= CGPointMake(origin.x, origin.y + size.height+1.0);
        i++;
    }
    selectionView.frame= CGRectMake(selectionView.frame.origin.x, selectionView.frame.origin.y, size.width+1, origin.y);
    return selectionView;
}

-(UIView*) mapView:(GMSMapView*) mapView needsDescriptions:(CLLocationCoordinate2D) location {
    NSArray* buttons= [NSArray arrayWithObjects:@"Cafe", @"Stops", @"Landmark", nil];
    
    CGPoint origin= CGPointMake(0.0, 0.0);
    CGSize size= CGSizeMake(100.0, 45.0);
    
    UIView* selectionView= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height * [buttons count])];
    
    [selectionView setBackgroundColor:[UIColor clearColor]];
    for (NSString* title in buttons) {
        UIButton* button= [[UIButton alloc] initWithFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[self secondDefaultColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        [button setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
            [self mapView:self.mapView dropped:title atLocation:location];
        }];
        [selectionView addSubview:button];
        origin= CGPointMake(origin.x, origin.y + size.height);
    }
    selectionView.frame= CGRectMake(selectionView.frame.origin.x, selectionView.frame.origin.y, size.width+1, origin.y);
    return selectionView;
}

-(void) mapView:(GMSMapView *)mapView dropped:(NSString*) type atLocation:(CLLocationCoordinate2D) location {
    self.calloutView.hidden= YES;
    if([type isEqualToString:@"Cafe"]) {
        [self mapView:self.mapView markerForCoordinate:location withMarkerImage:[UIImage imageNamed:@"coffee.png"] andType:@"Cafe"];
    } else if ([type isEqualToString:@"Stops"]) {
        [self mapView:self.mapView markerForCoordinate:location withMarkerImage:[UIImage imageNamed:@"halt.png"] andType:@"Stops"];
    } else if ([type isEqualToString:@"Landmark"]) {
        [self mapView:self.mapView markerForCoordinate:location withMarkerImage:[UIImage imageNamed:@"landmark.png"] andType:@"Landmark"];
    } else if ([type isEqualToString:@"Waypoint"]) {
        [self nearestKnownLocation:location];
        NSString* imageName= @"end-marker.png";
        if (![self.markers count]) {
            self.markers= [[NSMutableArray alloc] init];
            imageName= @"start-marker.png";
        }
        [self mapView:self.mapView markerForCoordinate:location withMarkerImage:[UIImage imageNamed:imageName] andType:@"Waypoint"];
        [self updateMarkers];
    }
}


-(void) mapView:(GMSMapView *) mapView markerForCoordinate:(CLLocationCoordinate2D) coordinate withMarkerImage:(UIImage*) image andType:(NSString*) type {

    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.userData= markerInfo;
    marker.position = coordinate;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = image;
    marker.map = mapView;
    marker.tappable= YES;
    
    MarkerInfo* markerInfo= [[MarkerInfo alloc] init];
    markerInfo.title= @"";
    markerInfo.markerDescription= @"";
    markerInfo.latitude= coordinate.latitude;
    markerInfo.longitude= coordinate.longitude;
    markerInfo.type= type;
    marker.userData= markerInfo;

    
    [self.markers addObject:marker];
    
    [self titleAndSubtitleForMarker:marker forType:type];
}

-(void) updateMarkers {
    BOOL beyondFirstFlag= NO;
    
    NSInteger waypoints= 0;
    
    GMSMarker* lastMarker;
    
    for (GMSMarker* marker in self.markers) {
        MarkerInfo* markerInfo= marker.userData;
            lastMarker= marker;
        if ([markerInfo.type isEqualToString:@"Waypoint"]) {
            waypoints++;
        }
        if ([markerInfo.type isEqualToString:@"Waypoint"] && !beyondFirstFlag) {
            beyondFirstFlag= YES;
            continue;
        }
        if ([markerInfo.type isEqualToString:@"Waypoint"]) {
            lastMarker.icon= [UIImage imageNamed:@"way-point.png"];
        }
        
    }
    if (waypoints > 1) {
        lastMarker.icon= [UIImage imageNamed:@"end-marker.png"];
    }
}

-(void) showPopup:(NSString*) title subtitle:(NSString*) subtitle type:(NSString*) type {
    Popup *popup = [[Popup alloc] initWithTitle:@"Cruizeco"
                                       subTitle:[NSString stringWithFormat:@"Provide a title and subtitle for this %@. The informations provided here will be displayed everytime this %@ is tapped on the map.", type, type]
                          textFieldPlaceholders:@[@"Title (max 5 words)", @"Description max (250 characters)"]
                                    cancelTitle:@"Cancel"
                                   successTitle:@"Ok"
                                    cancelBlock:^{
                                    } successBlock:^{
                                    }];
    if ([title isEqualToString:@"Not Set"]) {
        title= nil;
    }

    if ([subtitle isEqualToString:@"Not Set"]) {
        subtitle= nil;
    }
    
    title= (!title)? @"":title;
    subtitle= (!subtitle)? @"":subtitle;
    [popup setTextFieldTextForTextFields:[NSArray arrayWithObjects:title,subtitle, nil]];
    [popup setBackgroundColor:[UIColor whiteColor]];
    //    [popup setBorderColor:[UIColor blackColor]];
    //    [popup setTitleColor:[UIColor darkGrayColor]];
    //
    //    [popup setSubTitleColor:[UIColor lightTextColor]];
    [popup setSuccessBtnColor:[self defaultColor]];
    //    [popup setSuccessTitleColor:[UIColor whiteColor]];
    [popup setCancelBtnColor:[self secondDefaultColor]];
    //    [popup setCancelTitleColor:[UIColor whiteColor]];
    //
    [popup setIncomingTransition:PopupIncomingTransitionTypeBounceFromCenter];
    [popup setOutgoingTransition:PopupOutgoingTransitionTypeBounceFromCenter];
    [popup setBackgroundBlurType:PopupBackGroundBlurTypeDark];
    [popup setRoundedCorners:YES];
    [popup setTapBackgroundToDismiss:YES];
    [popup setDelegate:self];
    [popup showPopup];
}

-(void) titleAndSubtitleForMarker:(GMSMarker*) marker forType:(NSString*) type {
    self.activeMarker= marker;
    [self showPopup:nil subtitle:nil type:type];
}

- (void) dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray {
    
    NSString *title = [stringArray objectAtIndex:0];
    NSString *subtitle = [stringArray objectAtIndex:1];
    
    MarkerInfo* markerInfo= self.activeMarker.userData;
    markerInfo.title= (title.length)? title: @"Not Set";
    markerInfo.markerDescription= (subtitle.length)? subtitle: @"Not Set";
    self.calloutView.title= markerInfo.title;
    [self mapView:self.mapView didTapMarker:self.activeMarker];
}



#pragma mark Google Places
-(void) nearestKnownLocation:(CLLocationCoordinate2D) coordinate {
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@latlng=%f,%f&radius=500&key=%@", gReverseGeocode, coordinate.latitude, coordinate.longitude, gPlacesAPIKEY] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* results= [responseObject objectForKey:@"results"];
        NSString* placeId= [[results firstObject] objectForKey:@"place_id"];
        [self.placesIds addObject:placeId];
        if ([self.placesIds count] > 1) {
            NSInteger count= [self.placesIds count] - 1;
            [self generateWaypointsFrom:[self.placesIds objectAtIndex:count] to:[self.placesIds objectAtIndex:count-1]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
#pragma mark Google Directions API
-(void) generateWaypointsFrom:(NSString*) placeIdOrigin to:(NSString*) placeIdDestination {
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@origin=place_id:%@&destination=place_id:%@&alternatives=true&mode=%@&key=%@", gDirectionsBaseURL, placeIdOrigin, placeIdDestination, self.travelMode, gPlacesAPIKEY] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int index= 0;
        NSMutableArray* waypointRoutes= [[NSMutableArray alloc] init];
        for (id object in [responseObject objectForKey:@"routes"]) {
            GMRoute* route= [[GMRoute alloc] initWithAttributes:object];
            route.isUserChoice= (!index)? YES: NO;
            index++;
            [waypointRoutes addObject:route];
        }
        [self.routes addObject:waypointRoutes];
        self.activeWaypoint= [self.routes count];
        [self mapView:self.mapView plotRoutes:self.routes];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void) mapView:(GMSMapView *)mapView plotRoutes:(NSMutableArray *)routes {
    int i_waypoint= 0;
    for (NSArray* waypoints in self.routes) {
        int index= 0;
        for (GMRoute* route in waypoints) {
            if (!route.polyLine) {
                GMSPath *path = [GMSPath pathFromEncodedPath:route.overviewPolyline];
                route.polyLine = [GMSPolyline polylineWithPath:path];
            }
            route.polyLine.strokeWidth = 5.f;
            route.polyLine.zIndex= 0;
            route.polyLine.tappable= YES;
            route.polyLine.title= [NSString stringWithFormat:@"%d,%d", i_waypoint, index];
            UIColor* strokeColor= [UIColor lightGrayColor];
            if (route.isUserChoice) {
                strokeColor= [self secondDefaultColor];
                if (self.activeWaypoint-1 != i_waypoint) {
                    strokeColor= [UIColor blueColor];
                }
                route.polyLine.zIndex= 1;
                route.polyLine.map= mapView;
            } else {
                if (self.activeWaypoint-1 != i_waypoint ) {
                    route.polyLine.map= nil;
                } else {
                    route.polyLine.map= mapView;
                }
            }
            route.polyLine.strokeColor= strokeColor;
            index++;
        }
        i_waypoint++;
        
        [self generateMetricsForWaypoint:([self.routes count] - 1) andWaypointIndex:0];
    }
}

-(void) mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay {
    NSArray* str_indexPath = [overlay.title componentsSeparatedByString: @","];
    int indexWaypoint= [[str_indexPath objectAtIndex:0] intValue];
    int indexRoute= [[str_indexPath objectAtIndex:1] intValue];
    for (int i_waypoint= 0; i_waypoint < [self.routes count]; i_waypoint++) {
        int index= 0;
        for (GMRoute* route in [self.routes objectAtIndex:i_waypoint]) {
            //route.polyLine.map= nil;
            if (indexWaypoint == i_waypoint) {
                if (indexRoute == index) {
                    route.isUserChoice= YES;
                    route.polyLine.zIndex= 1;
                    route.polyLine.strokeColor= [self secondDefaultColor];
                } else {
                    route.isUserChoice= NO;
                    route.polyLine.zIndex= 0;
                    route.polyLine.strokeColor= [UIColor lightGrayColor];
                }
                route.polyLine.map = mapView;
            } else {
                if (!route.isUserChoice) {
                    route.polyLine.map= nil;
                } else {
                    route.polyLine.strokeColor= [UIColor blueColor];
                    route.polyLine.map= mapView;
                }
            }
            index++;
        }
    }
    [self generateMetricsForWaypoint:indexWaypoint andWaypointIndex:indexRoute];
}

-(void) generateMetricsForWaypoint:(NSInteger) routeIndex andWaypointIndex:(NSInteger) waypointIndex {
    
    NSInteger trackDistance= 0;
    NSInteger trackDurationSeconds= 0;
    NSInteger waypointDistance= 0;
    NSInteger waypointDurationSeconds= 0;
    
    for (int i_waypoint= 0; i_waypoint < [self.routes count]; i_waypoint++) {
        int index= 0;
        for (GMRoute* route in [self.routes objectAtIndex:i_waypoint]) {
            //route.polyLine.map= nil;
            if (routeIndex == i_waypoint) {
                if (waypointIndex == index) {
                    waypointDistance= route.distance;
                    waypointDurationSeconds= route.duration;
                }
            }
            if (route.isUserChoice) {
                trackDistance+= route.distance;
                trackDurationSeconds+= route.duration;
            }
            index++;
        }
    }
    NSString* trackDistanceText= [self kmDistanceFromMeters:trackDistance];
    NSString* trackDurationText= [self stringifyDurationFromSeconds:trackDurationSeconds];
    NSString* waypointDistanceText= [self kmDistanceFromMeters:waypointDistance];
    NSString* waypointDurationText= [self stringifyDurationFromSeconds:waypointDurationSeconds];
    
    [self updateTrackDistance:trackDistanceText trackDuration:trackDurationText waypointDistance:waypointDistanceText andWaypointDuration:waypointDurationText];

}

@end
