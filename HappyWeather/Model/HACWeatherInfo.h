//
//  HACWeatherInfo.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/28.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HACWeatherInfo : NSObject

@property (nonatomic, copy, readonly) NSString *dt;
@property (nonatomic, copy, readonly) NSString *main;
@property (nonatomic, copy, readonly) NSString *weatherDesc;
@property (nonatomic, copy, readonly) NSString *icon;
@property (nonatomic, copy, readonly) NSString *temp;
@property (nonatomic, copy, readonly) NSString *tempMax;
@property (nonatomic, copy, readonly) NSString *tempMin;
@property (nonatomic, copy, readonly) NSString *pressure;
@property (nonatomic, copy, readonly) NSString *windSpeed;

- (NSString *)minTemperature;
- (NSString *)maxTemperature;

+ (void)createWeekWeatherWithLocation:(CLLocation *)location
                              success:(void (^)(NSArray *))success
                              failure:(void (^)(NSError *))failure;

+ (void)createCurrentWeatherWithLocation:(CLLocation *)location
                                 success:(void (^)(HACWeatherInfo *))success
                                 failure:(void (^)(NSError *))failure;

@end
