//
//  AppDelegate.h
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/3/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)enableParseAPI:(NSDictionary *)launchOptions;

@end

