//
//  Base.h
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/5/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>
#import <Parse/PFSubclassing.h>
#import <Parse/PFQuery.h>

@interface Base : PFObject <PFSubclassing>

+(NSString *)parseClassName;
+(PFQuery *)query;

@end
