//
//  HACWeatherTableViewCell.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/29.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HACWeatherCellIdentifier;

@class HACWeatherInfo;
@interface HACWeatherTableViewCell : UITableViewCell

- (void)configureCellWithWeatherInfo:(HACWeatherInfo *)weatherInfo;

@end
