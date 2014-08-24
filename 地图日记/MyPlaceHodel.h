//
//  MyPlaceHodel.h
//  地图日记
//
//  Created by chenguandong on 14-5-26.
//  Copyright (c) 2014年 chenguandong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "NoteBean.h"
@interface MyPlaceHodel :NoteBean <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property(nonatomic,strong)NoteBean *noteBean;

@end
