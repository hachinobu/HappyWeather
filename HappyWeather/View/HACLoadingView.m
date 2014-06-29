//
//  HACLoadingView.m
//  HappyWeather
//
//  Created by Takahiro Nishinobu on 2014/06/30.
//  Copyright (c) 2014年 Takahiro Nishinobu. All rights reserved.
//

#import "HACLoadingView.h"

@interface HACLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation HACLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.indicatorView.hidesWhenStopped = YES;
    self.indicatorView.center = self.center;
    [self.indicatorView startAnimating];
    [self addSubview:self.indicatorView];
}

- (void)showInSuperView:(UIView *)superview
               animated:(BOOL)animated
{
    self.frame = superview.bounds;
    self.indicatorView.center = self.center;
    
    if(!animated){
        [superview addSubview:self];
        return;
    }
    
    self.alpha = 0.0f;
    [superview addSubview:self];
    
    [UIView animateWithDuration:1.3f
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:NULL];
}

- (void)hideWithAnimated:(BOOL)animated
{
    if(!animated){
        [self removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:1.3f
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
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
