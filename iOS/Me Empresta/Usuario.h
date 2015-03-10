//
//  Usuario.h
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/5/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base.h"

@interface Usuario : Base{
    NSInteger usuarioId;
}

@property NSString *nome;
@property NSString *email;
@property NSString *senha;

+(NSString *)parseClassName;

@end
