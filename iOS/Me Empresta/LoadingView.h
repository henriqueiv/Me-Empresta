//
//  LoadingView.h
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/13/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property UIActivityIndicatorView *activitySpinner;
@property UILabel *loadingLabel;

- (instancetype)initWithText:(NSString*)text;
- (void)hide;

@end
