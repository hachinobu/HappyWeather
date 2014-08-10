//
//  HACWeatherDetailVC.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/08/06.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HACWeatherInfo;
@interface HACWeatherDetailVC : UIViewController

- (void)reloadDetailViewWithWeatherInfo:(HACWeatherInfo *)weatherInfo;

@end
