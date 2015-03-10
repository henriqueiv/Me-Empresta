//
//  Usuario.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/5/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import "Usuario.h"

@implementation Usuario

@synthesize email;
@synthesize nome;
@synthesize senha;

+(NSString *)parseClassName{
    return [super parseClassName];
}

@end
