//
//  TrackDetailViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 12/1/15.
//  Copyright © 2015 Kishor Kundan. All rights reserved.
//

#import "TrackDetailViewController.h"

#import <EDStarRating.h>
#import <SMCalloutView/SMCalloutView.h>
#import "TrackListTableViewCell.h"
#import "AutoSizingLabelOnlyTableViewCell.h"
#import "AddTrackViewController.h"

@interface TrackDetailViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;



@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;

@end



static const CGFloat CalloutYOffset = 50.0f;


@implementation TrackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.tableView.dataSource= self;
    self.tableView.delegate= self;

    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
}

-(void) setupUI {
    self.calloutView = [[SMCalloutView alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    self.calloutView.rightAccessoryView = button;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self populateMap];
}

#pragma mark Google Maps
-(void) populateMap {
    float cameraLatitude= 0;
    float cameraLongitude= 0;

    if ([self.trackInfo.markers count]) {
        for (MarkerInfo* markerInfo in self.trackInfo.markers) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.userData= markerInfo;
            marker.position = CLLocationCoordinate2DMake(markerInfo.latitude, markerInfo.longitude);
            marker.appearAnimation = kGMSMarkerAnimationPop;
//            marker.icon = [UIImage imageNamed:@"flag_icon"];
            marker.map = self.mapView;
            marker.icon= [GMSMarker markerImageWithColor:[UIColor colorWithRed:18/255.0 green:168/255.0 blue:171/255.0 alpha:1.0]];
            marker.tappable= YES;
            cameraLatitude= markerInfo.latitude;
            cameraLongitude= markerInfo.longitude;
        }
    }
    

    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:cameraLatitude
                                                            longitude:cameraLongitude
                                                                 zoom:12.5
                                                              bearing:30
                                                         viewingAngle:40];
    
//    [GMSCameraPosition cameraWithLatitude:cameraLatitude
//                                                            longitude:cameraLongitude
//                                                                 zoom:12];
    self.mapView.camera= camera;
    self.mapView.delegate= self;
    GMSMutablePath *path = [GMSMutablePath path];
    for (TrackPolyInfo* polyInfo in self.trackInfo.polyPoints) {
        [path addLatitude:polyInfo.latitude longitude:polyInfo.longitude];
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
//        18 168 171
    polyline.strokeColor = [UIColor colorWithRed:18/255.0 green:168/255.0 blue:171/255.0 alpha:1.0];
    polyline.strokeWidth = 5.f;
    polyline.map = self.mapView;
    
    
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.zoomGestures= YES;
}


- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    CLLocationCoordinate2D anchor = marker.position;
    
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    
    MarkerInfo* markerInfo= marker.userData;
    self.calloutView.title = markerInfo.title;
    self.calloutView.subtitle= markerInfo.markerDescription;
    
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

- (void)mapView:(GMSMapView *)pMapView didChangeCameraPosition:(GMSCameraPosition *)position {
    /* move callout with map drag */
    if (pMapView.selectedMarker != nil && !self.calloutView.hidden) {
        CLLocationCoordinate2D anchor = [pMapView.selectedMarker position];
        
        CGPoint arrowPt = self.calloutView.backgroundView.arrowPoint;
        
        CGPoint pt = [pMapView.projection pointForCoordinate:anchor];
        pt.x -= arrowPt.x;
        pt.y -= arrowPt.y + CalloutYOffset;
        
        self.calloutView.frame = (CGRect) {.origin = pt, .size = self.calloutView.frame.size };
    } else {
        self.calloutView.hidden = YES;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.calloutView.hidden = YES;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    /* don't move map camera to center marker on tap */
    mapView.selectedMarker = marker;
    return YES;
}

- (void)calloutAccessoryButtonTapped:(id)sender {
    if (self.mapView.selectedMarker) {
        
        GMSMarker *marker = self.mapView.selectedMarker;
        NSDictionary *userData = marker.userData;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test"
                                                            message:@"s"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row;
    switch (section) {
        case 0:
            row= 2;
            break;
        case 1:
            row= 0;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 1) {
                
                AutoSizingLabelOnlyTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"AutoSizingLabelOnlyTVC" forIndexPath:indexPath];
                if (!cell)
                {
                    cell = [[AutoSizingLabelOnlyTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AutoSizingLabelOnlyTVC"];
                }
                cell.labelDescription.text= @"Very very long text. This is a dummy text, API is not providing track description. Very very long text. This is a dummy text, API is not providing track description.";
                return cell;
            }
            
            TrackListTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"TracksListTVC" forIndexPath:indexPath];
            if (!cell)
            {
                cell = [[TrackListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TracksListTVC"];
            }

            cell.labelTrackTitle.text= self.trackInfo.title;
            cell.labelDuration.text= self.trackInfo.duration;
            cell.labelDistance.text= self.trackInfo.distance;
            
            cell.starBox.starImage= [UIImage imageNamed:@"white-star.png"];
            cell.starBox.starHighlightedImage= [UIImage imageNamed:@"gold-star.png"];
            cell.starBox.maxRating= 5.0;
            cell.starBox.delegate = self;
            cell.starBox.horizontalMargin = 12;
            cell.starBox.editable=YES;
            cell.starBox.displayMode=EDStarRatingDisplayFull;
            cell.starBox.rating= [self.trackInfo.rating floatValue];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return [UITableViewCell class];
}


@end
