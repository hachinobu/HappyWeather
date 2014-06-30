//
//  HACWeatherDetailView.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/29.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HACWeatherInfo;
@interface HACWeatherDetailView : UIView

- (void)noActive;
- (void)configureViewWithWeatherInfo:(HACWeatherInfo *)weatherInfo;

@end
