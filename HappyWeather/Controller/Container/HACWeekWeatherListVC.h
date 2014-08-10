//
//  HACWeekWeatherVC.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/08/06.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HACWeatherInfo;

@protocol HACWeekWeatherListDelegate;

@interface HACWeekWeatherListVC : UITableViewController

@property (weak, nonatomic) NSObject<HACWeekWeatherListDelegate> *delegate;
- (void)reloadWeekWeatherInfo:(NSArray *)infos;

@end

@protocol HACWeekWeatherListDelegate <NSObject>

@required
- (void)reflectDetailWithSelectInfo:(HACWeatherInfo *)weatherInfo;

@end