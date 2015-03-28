//
//  LoadingView.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/13/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAlpha:0.75f];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        CGFloat labelHeight = 22;
        CGFloat labelWidth = self.frame.size.width - 20;
        
        // derive the center x and y
        CGFloat centerX = self.frame.size.width / 2;
        CGFloat centerY = self.frame.size.height / 2;
        
        // create the activity spinner, center it horizontall and put it 5 points above center x
        _activitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        CGFloat xFrameSpinner = centerX - _activitySpinner.frame.size.width/2;
        CGFloat yFrameSpinner = centerY - _activitySpinner.frame.size.height/2;
        _activitySpinner.frame = CGRectMake(xFrameSpinner, yFrameSpinner, _activitySpinner.frame.size.width, _activitySpinner.frame.size.height);
        
        [_activitySpinner setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self addSubview:_activitySpinner];
        _activitySpinner.startAnimating;
        
        // create and configure the "Loading Data" label
        CGRect labelFrame = CGRectMake(centerX - labelWidth/2,
                                       centerY - labelHeight/2,
                                       labelWidth,
                                       labelHeight);
        
        _loadingLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.textColor = [UIColor whiteColor];
        _loadingLabel.text = @"Loading Data...";
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        _loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:_loadingLabel];
    }
    return self;
}

- (instancetype)initWithText:(NSString*)text{
    self = [self init];
    _loadingLabel.text = text;
    return self;
}

- (void)hide{
    [self setAlpha:0.0f];
    [UIView animateWithDuration:0.5f animations:^{
        [self setAlpha:1.0f];
        [self removeFromSuperview];
    }];
}

@end
