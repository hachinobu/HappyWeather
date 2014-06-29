//
//  HACWeatherTableViewCell.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/29.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACWeatherTableViewCell.h"
#import "HACWeatherInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const HACWeatherCellIdentifier = @"weatherCell";

@interface HACWeatherTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end

@implementation HACWeatherTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)configureCellWithWeatherInfo:(HACWeatherInfo *)weatherInfo
{
    //画像
    NSURL *imageURL = [NSURL URLWithString:weatherInfo.icon];
    [self.weatherImage setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (cacheType != SDImageCacheTypeMemory) {
            [UIView transitionWithView:self.weatherImage
                              duration:1.28
                               options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                            animations:nil completion:nil];
        }
    }];
    
    //日付
    self.dateLabel.text = weatherInfo.dt;
    
    //気温
    NSDictionary *minAttributeDic = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]};
    NSAttributedString *minTemperature = [[NSAttributedString alloc] initWithString:[weatherInfo minTemperature] attributes:minAttributeDic];
    
    NSAttributedString *separator = [[NSAttributedString alloc] initWithString:@" " attributes:nil];
    
    NSDictionary *maxAttributeDic = @{NSForegroundColorAttributeName: [UIColor redColor],
                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]};
    NSAttributedString *maxTemperature = [[NSAttributedString alloc] initWithString:[weatherInfo maxTemperature] attributes:maxAttributeDic];
    
    NSMutableAttributedString *temperature = [[NSMutableAttributedString alloc] init];
    [temperature appendAttributedString:minTemperature];
    [temperature appendAttributedString:separator];
    [temperature appendAttributedString:maxTemperature];
    
    self.temperatureLabel.attributedText = temperature;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
