//
//  HACWeatherDetailView.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/29.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACWeatherDetailView.h"
#import "HACWeatherInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HACHappyWordManager.h"
#import "UIColor+HexColor.h"

typedef NS_ENUM(NSUInteger, ViewType) {
    DateViewType = 1,
    ImageViewType,
    MaxTempViewType,
    MinTempViewType,
    MessageViewType,
};

@interface HACWeatherDetailView ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *weatherImageView;
@property (nonatomic, strong) UILabel *maxTempLabel;
@property (nonatomic, strong) UILabel *minTempLabel;
@property (nonatomic, strong) UITextView *messageView;
@property (nonatomic, strong) UIImageView *noActiveImageView;

@end

@implementation HACWeatherDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.noActiveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 180.0f, 180.0f)];
    self.noActiveImageView.image = [UIImage imageNamed:@"notactive"];
    self.noActiveImageView.center = self.center;
    [self addSubview:self.noActiveImageView];
}

- (void)noActive
{
    self.noActiveImageView.hidden = NO;
}

- (void)clearContent
{
    self.dateLabel.text = @"";
    self.weatherImageView = nil;
    self.maxTempLabel.attributedText = nil;
    self.minTempLabel.attributedText = nil;
    self.messageView.text = @"";
    self.noActiveImageView.hidden = YES;
}

- (void)configureViewWithWeatherInfo:(HACWeatherInfo *)weatherInfo
{
    [self clearContent];
    
    self.dateLabel = (UILabel *)[self viewWithTag:DateViewType];
    self.dateLabel.text = weatherInfo.dt;
    
    //画像
    self.weatherImageView = (UIImageView *)[self viewWithTag:ImageViewType];
    __weak UIImageView *weakImageView = self.weatherImageView;
    NSURL *imageURL = [NSURL URLWithString:weatherInfo.icon];
    [self.weatherImageView setImageWithURL:imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (cacheType != SDImageCacheTypeMemory) {
            [UIView transitionWithView:weakImageView
                              duration:1.28
                               options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                            animations:nil completion:nil];
        }
    }];
    
    //最高気温
    self.maxTempLabel = (UILabel *)[self viewWithTag:MaxTempViewType];
    NSDictionary *maxAttributeDic = @{NSForegroundColorAttributeName: [UIColor redColor],
                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]};
    NSAttributedString *maxTemperature = [[NSAttributedString alloc] initWithString:[weatherInfo maxTemperature] attributes:maxAttributeDic];
    self.maxTempLabel.attributedText = maxTemperature;
    
    //最低気温
    self.minTempLabel = (UILabel *)[self viewWithTag:MinTempViewType];
    NSDictionary *minAttributeDic = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]};
    NSAttributedString *minTemperature = [[NSAttributedString alloc] initWithString:[weatherInfo minTemperature] attributes:minAttributeDic];
    self.minTempLabel.attributedText = minTemperature;
    
    //Happy Word
    self.messageView = (UITextView *)[self viewWithTag:MessageViewType];
    self.messageView.font = [UIFont systemFontOfSize:19.0f];
    self.messageView.textColor = [UIColor blueColor];
    
    NSRange seatchResult = [weatherInfo.weatherDesc rangeOfString:@"rain"];
    if (seatchResult.location == NSNotFound) {
        self.messageView.text = NSLocalizedString(@"いいことあるよ！\n幸せでありますように！", nil);
        self.messageView.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor hac_colorWithHexString:@"#FAFAD2"];
        return;
    }
    
    HACHappyWordManager *happyMg = [HACHappyWordManager sharedClient];
    NSString *happyText = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"[雨の日の幸せフレーズ]", nil), [happyMg randomHappyWord]];
    self.messageView.text = happyText;
    self.backgroundColor = [UIColor hac_colorWithHexString:@"#AFEEEE"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
