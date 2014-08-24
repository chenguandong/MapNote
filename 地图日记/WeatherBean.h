//
//  WeatherBean.h
//  LocalAndMap
//
//  Created by chenguandong on 13-12-4.
//  Copyright (c) 2013年 chenguandong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherBean : NSObject

@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *weather;
@property(nonatomic,strong)NSString *wind;
@property(nonatomic,strong)NSString *temperature;
-(id)initWeatherBeanWith:(NSString*)img andDate:(NSString*)date andWeather:(NSString*)weather andwind:(NSString*)wind andTemperture:(NSString*)temperture;
@end
