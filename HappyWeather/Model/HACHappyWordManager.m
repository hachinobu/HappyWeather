//
//  HACHappyWordManager.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/30.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACHappyWordManager.h"

static NSString * const HACHappyWordFile = @"HappyWord.plist";

@interface HACHappyWordManager ()

@property (nonatomic, strong) NSArray *happyWords;

@end

@implementation HACHappyWordManager

+ (HACHappyWordManager *)sharedClient
{
    static HACHappyWordManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithFileName:HACHappyWordFile];
    });
    
    return _sharedClient;
}

- (instancetype)initWithFileName:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *happyData = [NSData dataWithContentsOfFile:filePath];
    NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
    NSError *error;
    self.happyWords = [NSPropertyListSerialization propertyListWithData:happyData options:(NSPropertyListReadOptions)NSPropertyListImmutable format:&format error:&error];
    if (!self.happyWords) {
        return nil;
    }
    
    return self;
}

- (NSString *)randomHappyWord
{
    NSUInteger randomNum = arc4random() % [self.happyWords count];
    return self.happyWords[randomNum];
}

@end
