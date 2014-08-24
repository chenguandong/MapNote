//
//  MapViewController.h
//  地图日记
//
//  Created by chenguandong on 14-5-23.
//  Copyright (c) 2014年 chenguandong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(weak,nonatomic)NSArray *arrayNoteBeans;
@end
