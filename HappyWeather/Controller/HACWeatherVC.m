//
//  HACWeatherVC.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/08/07.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACWeatherVC.h"
#import "HACWeatherInfo.h"
#import "HACAddressInfo.h"
#import "HACWeatherDetailVC.h"
#import "HACWeekWeatherListVC.h"
#import "HACLoadingView.h"

@interface HACWeatherVC () <CLLocationManagerDelegate, HACWeekWeatherListDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *weekWeatherInfos;
@property (nonatomic, strong) HACWeatherDetailVC *weatherDetailVC;
@property (nonatomic, strong) HACWeekWeatherListVC *weatherListVC;

@end

@implementation HACWeatherVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWeekWeather)];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadWeekWeather
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        
        if ([self.weekWeatherInfos count] == 0) {
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"設定 > プライバシー > 位置情報サービスからHappyWeatherによる位置情報の利用を許可してください。", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)reloadDetailViewWithWeatherInfo:(HACWeatherInfo *)weatherInfo
{
    [UIView transitionWithView:self.weatherDetailVC.view duration:1.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [self.weatherDetailVC reloadDetailViewWithWeatherInfo:weatherInfo];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"weatherDetail"]) {
        self.weatherDetailVC = segue.destinationViewController;
    }
    else if ([identifier isEqualToString:@"weatherList"]) {
        self.weatherListVC = segue.destinationViewController;
        self.weatherListVC.delegate = self;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    if([newLocation.timestamp timeIntervalSinceNow] > 60) {
        return;
    }
    
    [self.locationManager stopUpdatingLocation];
    
    // 地名の読み込み
    [HACAddressInfo addressWithLocation:newLocation success:^(HACAddressInfo *addressInfo) {
        self.title = [addressInfo currentPlace];
    } failure:^(NSError *error) {
        self.title = NSLocalizedString(@"Happy Weather", nil);
    }];
    
    // 1週間の天気情報
    [HACWeatherInfo createWeekWeatherWithLocation:newLocation success:^(NSArray *weatherInfos) {
        
        HACLoadingView *loadView = [[HACLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [loadView showInSuperView:self.navigationController.view animated:YES];
        self.weekWeatherInfos = weatherInfos;
        [self.weatherListVC reloadWeekWeatherInfo:self.weekWeatherInfos];
        [self reloadDetailViewWithWeatherInfo:[self.weekWeatherInfos firstObject]];
        [loadView hideWithAnimated:YES];
        
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error userInfo][@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }];
}

#pragma mark - HACWeekWeatherListDelegate
- (void)reflectDetailWithSelectInfo:(HACWeatherInfo *)weatherInfo
{
    [self reloadDetailViewWithWeatherInfo:weatherInfo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
