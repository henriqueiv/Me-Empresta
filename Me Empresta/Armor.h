//
//  Armor.h
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/5/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Armor : NSObject//PFObject<PFSubclassing>

+ (NSString *)parseClassName;
@property (retain) NSString *displayName;
@property int rupees;
@property BOOL fireproof;

@end
