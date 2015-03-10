//
//  Emprestimo.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/3/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import "Emprestimo.h"

@implementation Emprestimo

@synthesize descricao;
@synthesize para;
@synthesize de;
@synthesize tags;
@synthesize dataEmprestimo;
@synthesize dataDevolucao;
@synthesize imagem;

+(NSString *)parseClassName{
    return NSStringFromClass([self class]);
}

@end
