//
//  HACWeekWeatherVC.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/08/06.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACWeekWeatherListVC.h"
#import "HACWeatherVC.h"
#import "HACWeatherTableViewCell.h"
#import "HACWeatherInfo.h"

@interface HACWeekWeatherListVC ()

@property (strong, nonatomic) IBOutlet UITableView *weatherTableView;
@property (strong, nonatomic) NSArray *weekWeatherInfos;

@end

@implementation HACWeekWeatherListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Action
- (void)reloadWeekWeatherInfo:(NSArray *)infos
{
    self.weekWeatherInfos = infos;
    [self.weatherTableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.weekWeatherInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HACWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HACWeatherCellIdentifier];
    [cell configureCellWithWeatherInfo:self.weekWeatherInfos[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate reflectDetailWithSelectInfo:self.weekWeatherInfos[indexPath.row]];
}

@end
