//
//  AdressSearchTableViewController.h
//  地图日记
//
//  Created by chenguandong on 14-5-26.
//  Copyright (c) 2014年 chenguandong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@protocol changeAdressDelegate <NSObject>

-(void)getAdress:(MKMapItem*)mapItem;

@end
@interface AdressSearchTableViewController : UITableViewController<UISearchBarDelegate,CLLocationManagerDelegate>
@property(weak,nonatomic)IBOutlet UISearchBar *searBar;
@property (strong,nonatomic) NSMutableArray *candyArray;
@property(nonatomic,weak)id<changeAdressDelegate>adressDelegate;

@end

