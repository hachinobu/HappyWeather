//
//  HACHappyWordManager.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/30.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HACHappyWordManager : NSObject

+ (HACHappyWordManager *)sharedClient;
- (NSString *)randomHappyWord;

@end
