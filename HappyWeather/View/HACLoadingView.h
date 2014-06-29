//
//  HACLoadingView.h
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/30.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HACLoadingView : UIView

- (void)showInSuperView:(UIView *)superview
               animated:(BOOL)animated;

- (void)hideWithAnimated:(BOOL)animated;

@end
