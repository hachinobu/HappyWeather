//
//  UIColor+HexColor.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/30.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)hac_colorWithHexString:(NSString *)hex
{
    //先頭に#がついていた場合は#を削除
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    unsigned int rgb[3];
    for (int i = 0; i < 3; i++) {
        NSString *component = [hex substringWithRange:NSMakeRange(i * 2, 2)];
        NSScanner *scanner = [NSScanner scannerWithString:component];
        [scanner scanHexInt:&rgb[i]];
    }
    return [UIColor colorWithRed:rgb[0]/255.0 green:rgb[1]/255.0 blue:rgb[2]/255.0 alpha:1.0f];
}

@end
