//
//  HACAddressInfo.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/29.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACAddressInfo.h"
#import "HACGoogleGeocodingAPI.h"

@interface HACAddressInfo ()

@property (nonatomic, copy) NSString *locality;
@property (nonatomic, copy) NSString *subLocality;

@end

@implementation HACAddressInfo

+ (instancetype)addressInfoWithData:(NSDictionary *)addressData
{
    HACAddressInfo *addressInfo = [[HACAddressInfo alloc] init];
    NSDictionary *addressDic = [addressData[@"results"] firstObject];
    NSArray *addressComponents = addressDic[@"address_components"];
    
    addressInfo.locality = [[addressComponents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"types", @[@"locality", @"political"]]] firstObject][@"long_name"];
    
    addressInfo.subLocality = [[addressComponents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"types", @[@"sublocality_level_1", @"sublocality", @"political"]]] firstObject][@"long_name"];
    
    return addressInfo;
}

+ (void)addressWithLocation:(CLLocation *)location
                    success:(void (^)(HACAddressInfo *))success
                    failure:(void (^)(NSError *))failure
{
    HACGoogleGeocodingAPI *apiClient = [HACGoogleGeocodingAPI sharedClient];
    NSString *lating = [NSString stringWithFormat:@"%f,%f",
                        location.coordinate.latitude, location.coordinate.longitude];
    NSDictionary *parameters = @{@"latlng": lating,
                                 @"sensor": @"true"};
    
    [apiClient addressInfoWithPath:@"json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        HACAddressInfo *addressInfo = [HACAddressInfo addressInfoWithData:responseObject];
        if (success) {
            success(addressInfo);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

- (NSString *)currentPlace
{
    if ([self.locality length] > 0 && [self.subLocality length] > 0) {
        return [NSString stringWithFormat:@"%@ %@", self.locality, self.subLocality];
    }
    return self.locality;
}

@end
