//
//  MapViewController.m
//  地图日记
//
//  Created by chenguandong on 14-5-23.
//  Copyright (c) 2014年 chenguandong. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "NoteBean.h"
#import "MyPlaceHodel.h"
#import "NoteDetailViewController.h"
#import "NoteBean.h"
@interface MapViewController ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MKPlacemark *placemark;
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.geocoder = [[CLGeocoder alloc] init];
    _mapView.delegate = self;
    

    
    for (NoteBean *noteBean in _arrayNoteBeans) {
        //设置地图中心
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = noteBean.note_lat;
        coordinate.longitude = noteBean.note_lng;
        
        
        MyPlaceHodel *ann = [[MyPlaceHodel alloc] init];
        ann.noteBean = noteBean;
        [ann setCoordinate:coordinate];
        [ann setTitle:noteBean.note_title];
        
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:noteBean.note_time];
        
        [ann setSubtitle:currentDateStr];
        //触发viewForAnnotation
        [ann setNote_ID:noteBean.note_ID];
        
        [_mapView addAnnotation:ann];
        
        
    }
    

   
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
    //地图位置中心位置改变
    NSLog(@"______regionWillChangeAnimated");
    
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //地图中心点坐标
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    
    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    NSLog(@"______didUpdateUserLocation" );
    
    self.mapView.centerCoordinate = [userLocation coordinate];
    
    //_mapView.showsUserLocation = NO;

}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:defaultPinID] ;
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeInfoLight];

        
        pinView.rightCalloutAccessoryView =rightBar;
    }
    else {
        [mapView.userLocation setTitle:@"当前位置"];
        [mapView.userLocation setSubtitle:@"您的当前位置"];
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
   // MKPointAnnotation *anno = (MKPointAnnotation *)view.annotation;
    
        MyPlaceHodel *anno = (MyPlaceHodel *)view.annotation;
    NoteDetailViewController *detailView = [NoteDetailViewController new];
    
    detailView.noteBean = anno.noteBean;
    
    [self.navigationController pushViewController:detailView animated:YES];
    NSLog(@"8888%@",anno.title);
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    

    MyPlaceHodel *anno = (MyPlaceHodel *)view.annotation;
    
  
    
    NSLog(@"ID=%d",anno.note_ID);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
