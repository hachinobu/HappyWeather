//
//  HACWeatherInfo.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/28.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACWeatherInfo.h"
#import "HACOpenWeatherMapAPI.h"
#import "NSDateUtils.h"

static NSString * const HACWeatherIconURLString = @"http://openweathermap.org/img/w/%@.png";

@interface HACWeatherInfo ()

@property (nonatomic, copy, readwrite) NSString *dt;
@property (nonatomic, copy, readwrite) NSString *main;
@property (nonatomic, copy, readwrite) NSString *weatherDesc;
@property (nonatomic, copy, readwrite) NSString *icon;
@property (nonatomic, copy, readwrite) NSString *temp;
@property (nonatomic, copy, readwrite) NSString *tempMax;
@property (nonatomic, copy, readwrite) NSString *tempMin;
@property (nonatomic, copy, readwrite) NSString *pressure;
@property (nonatomic, copy, readwrite) NSString *windSpeed;

@end

@implementation HACWeatherInfo

+ (instancetype)commonWeatherInfoWithData:(NSDictionary *)weatherData
{
    HACWeatherInfo *weatherInfo = [[HACWeatherInfo alloc] init];
    NSString *unixTime = [weatherData[@"dt"] stringValue];
    weatherInfo.dt = [NSDateUtils convertFormatDateWithUnixTime:unixTime];
    weatherInfo.main = [weatherData[@"weather"] firstObject][@"main"];
    weatherInfo.weatherDesc = [weatherData[@"weather"] firstObject][@"description"];
    NSString *iconName = [weatherData[@"weather"] firstObject][@"icon"];
    weatherInfo.icon = [NSString stringWithFormat:HACWeatherIconURLString, iconName];
    
    return weatherInfo;
}

+ (instancetype)weekWeatherInfoWithData:(NSDictionary *)weatherData
{
    HACWeatherInfo *weatherInfo = [HACWeatherInfo commonWeatherInfoWithData:weatherData];
    weatherInfo.tempMax = [weatherData[@"temp"][@"max"] stringValue];
    weatherInfo.tempMin = [weatherData[@"temp"][@"min"] stringValue];
    
    return weatherInfo;
}

+ (instancetype)currentWeatherInfoWithData:(NSDictionary *)weatherData
{
    HACWeatherInfo *weatherInfo = [HACWeatherInfo commonWeatherInfoWithData:weatherData];
    weatherInfo.temp = [weatherData[@"main"][@"temp"] stringValue];
    weatherInfo.tempMax = [weatherData[@"main"][@"temp_max"] stringValue];
    weatherInfo.tempMin = [weatherData[@"main"][@"temp_min"] stringValue];
    weatherInfo.pressure = [weatherData[@"main"][@"pressure"] stringValue];
    weatherInfo.windSpeed = [weatherData[@"wind"][@"speed"] stringValue];
    
    return weatherInfo;
}

- (NSString *)formatWithTemperature:(NSString *)temp
{
    return [NSString stringWithFormat:@"%d ℃", [temp integerValue]];
}

- (NSString *)minTemperature
{
    
    NSString *minTemp = [self formatWithTemperature:self.tempMin];
    return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"最低気温:", nil), minTemp];
}

- (NSString *)maxTemperature
{
    NSString *maxTemp = [self formatWithTemperature:self.tempMax];
    return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"最高気温:", nil), maxTemp];
}

+ (void)createWeekWeatherWithLocation:(CLLocation *)location
                              success:(void (^)(NSArray *))success
                              failure:(void (^)(NSError *))failure
{
    HACOpenWeatherMapAPI *apiClient = [HACOpenWeatherMapAPI sharedClient];
    NSDictionary *parameters = @{@"units": @"metric",
                                 @"lat": @(location.coordinate.latitude),
                                 @"lon": @(location.coordinate.longitude),
                                 @"cnt": @7,
                                 @"mode": @"json"};
    
    [apiClient weatherInfoWithPath:@"forecast/daily" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *weatherList = responseObject[@"list"];
        NSMutableArray *weatherInfos = [NSMutableArray array];
        
        for (NSDictionary *weatherData in weatherList) {
            HACWeatherInfo *weatherInfo = [HACWeatherInfo weekWeatherInfoWithData:weatherData];
            [weatherInfos addObject:weatherInfo];
        }
        
        if (success) {
            success([weatherInfos copy]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

+ (void)createCurrentWeatherWithLocation:(CLLocation *)location
                                 success:(void (^)(HACWeatherInfo *))success
                                 failure:(void (^)(NSError *))failure
{
    HACOpenWeatherMapAPI *apiClient = [HACOpenWeatherMapAPI sharedClient];
    NSDictionary *parameters = @{@"units": @"metric",
                                 @"lat": @(location.coordinate.latitude),
                                 @"lon": @(location.coordinate.longitude),
                                 @"mode": @"json"};
    
    [apiClient weatherInfoWithPath:@"weather" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        HACWeatherInfo *weatherInfo = [HACWeatherInfo currentWeatherInfoWithData:responseObject];
        if (success) {
            success(weatherInfo);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}




@end
