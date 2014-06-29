//
//  HACAddressInfo.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/29.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HACAddressInfo : NSObject

+ (void)addressWithLocation:(CLLocation *)location
                    success:(void (^)(HACAddressInfo *))success
                    failure:(void (^)(NSError *))failure;

- (NSString *)currentPlace;

@end
