//
//  HACGoogleGeocodingAPI.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/29.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACGoogleGeocodingAPI.h"

static NSString * const HACGoogleGeocodingBaseURLString = @"http://maps.googleapis.com/maps/api/geocode/";

@implementation HACGoogleGeocodingAPI

+ (HACGoogleGeocodingAPI *)sharedClient
{
    static HACGoogleGeocodingAPI *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:HACGoogleGeocodingBaseURLString]];
    });
    
    return _sharedClient;
}

- (void)addressInfoWithPath:(NSString *)path
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
