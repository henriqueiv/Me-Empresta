//
//  Base.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/5/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import "Base.h"

@implementation Base

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

@end
