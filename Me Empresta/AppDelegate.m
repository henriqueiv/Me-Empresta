//
//  AppDelegate.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/3/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//


#import "AppDelegate.h"
#define PARSE_APPLICATION_ID "I8MUBz2vwKB33V6poVIIOxhmEyBV8kkt329Ci4SN"
#define PARSE_CLIENT_KEY "anqCuGkGXBg9OZoexXlVVkVHpYIaZK7jXseyplyG"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setStatusBarColor];
    [self enableParseAPI:launchOptions];
    
    return YES;
}


- (void)setStatusBarColor{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0f/255.0f
                                                                  green:179/255.0f
                                                                   blue:107/255.0f
                                                                  alpha:1.0f]];
}


- (void)enableParseAPI:(NSDictionary *)launchOptions{
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@PARSE_APPLICATION_ID
                  clientKey:@PARSE_CLIENT_KEY];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

@end
