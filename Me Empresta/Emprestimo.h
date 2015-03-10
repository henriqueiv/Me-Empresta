//
//  Emprestimo.h
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/3/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Emprestimo : NSObject{
    NSInteger emprestimoId;
}

@property (nonatomic) NSString *descricao;
@property (nonatomic) NSString *de;
@property (nonatomic) NSString *para;
@property (nonatomic) NSMutableArray *tags;
@property (nonatomic) NSDate *dataEmprestimo;
@property (nonatomic) NSDate *dataDevolucao;
@property (nonatomic) UIImage *imagem;

@end
