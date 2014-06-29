//
//  NSDateUtils.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/29.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "NSDateUtils.h"

@implementation NSDateUtils

static NSDateFormatter *formatter = nil;

+ (NSString *)convertFormatDateWithUnixTime:(NSString *)unixTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixTime doubleValue]];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    formatter.dateFormat = @"MM/dd";
    
    return [formatter stringFromDate:date];
}

@end
