//
//  HACOpenWeatherMapAPI.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/28.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACOpenWeatherMapAPI.h"

static NSString * const HACOpenWeatherMapBaseURLString = @"http://api.openweathermap.org/data/2.5/";

@implementation HACOpenWeatherMapAPI

+ (HACOpenWeatherMapAPI *)sharedClient
{
    static HACOpenWeatherMapAPI *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:HACOpenWeatherMapBaseURLString]];
    });
    
    return _sharedClient;
}

- (void)weatherInfoWithPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    [self GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
}

@end
