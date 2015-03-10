//
//  DetalheEmprestimoViewController.h
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/9/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emprestimo.h"
#import <Parse/Parse.h>

@interface DetalheEmprestimoViewController : UIViewController <UIAlertViewDelegate>

@property (strong, atomic) PFObject *emprestimo;
@property (strong, atomic) UIImage *imagem;
@property (getter=isEditing) BOOL editing;

@end
