//
//  HACOpenWeatherMapAPI.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/28.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface HACOpenWeatherMapAPI : AFHTTPSessionManager

+ (HACOpenWeatherMapAPI *)sharedClient;

- (void)weatherInfoWithPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
