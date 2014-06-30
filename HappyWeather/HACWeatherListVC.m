//
//  HACViewController.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/28.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACWeatherListVC.h"
#import "HACWeatherInfo.h"
#import "HACAddressInfo.h"
#import "HACWeatherTableViewCell.h"
#import "HACWeatherDetailView.h"
#import "HACLoadingView.h"
#import "Reachability.h"

@interface HACWeatherListVC () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *weekWeatherInfos;
@property (weak, nonatomic) IBOutlet UITableView *weatherTableView;
@property (weak, nonatomic) IBOutlet HACWeatherDetailView *weatherDetailView;

@end

@implementation HACWeatherListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWeekWeather)];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    UINib *nib = [UINib nibWithNibName:@"HACWeatherTableViewCell" bundle:nil];
    [self.weatherTableView registerNib:nib forCellReuseIdentifier:HACWeatherCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadWeekWeather
{
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"ネットワーク接続を確認してください", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        
        if ([self.weekWeatherInfos count] == 0) {
            [self.weatherDetailView noActive];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"設定 > プライバシー > 位置情報サービスからHappyWeatherによる位置情報の利用を許可してください。", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)reloadDetailViewWithWeatherInfo:(HACWeatherInfo *)weatherInfo
{
    [self.weatherDetailView configureViewWithWeatherInfo:weatherInfo];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.weekWeatherInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HACWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HACWeatherCellIdentifier];
    [cell configureCellWithWeatherInfo:self.weekWeatherInfos[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self reloadDetailViewWithWeatherInfo:self.weekWeatherInfos[indexPath.row]];
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
        [self.weatherTableView reloadData];
        [self reloadDetailViewWithWeatherInfo:[self.weekWeatherInfos firstObject]];
        [loadView hideWithAnimated:YES];
        
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error userInfo][@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }];
}

@end
