//
//  HACGoogleGeocodingAPI.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/29.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface HACGoogleGeocodingAPI : AFHTTPSessionManager

+ (HACGoogleGeocodingAPI *)sharedClient;
- (void)addressInfoWithPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
