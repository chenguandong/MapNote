//
//  WeatherBean.m
//  LocalAndMap
//
//  Created by chenguandong on 13-12-4.
//  Copyright (c) 2013年 chenguandong. All rights reserved.
//

#import "WeatherBean.h"

@implementation WeatherBean

@synthesize img,date,weather,temperature;

- (id)initWeatherBeanWith:(NSString *)img andDate:(NSString *)date andWeather:(NSString *)weather andwind:(NSString *)wind andTemperture:(NSString *)temperture
{
    self = [super init];
    if (self) {
        self.img = img;
        self.date = date;
        self.weather = weather;
        self.temperature = temperture;
    }
    return self;
}
@end
