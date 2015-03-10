//
//  Armor.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/5/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import "Armor.h"
#import <Parse/PFObject+Subclass.h>

@implementation Armor
@dynamic displayName;
@dynamic rupees;
@dynamic fireproof;
+ (NSString *)parseClassName {
    return @"Armor";
}
@end