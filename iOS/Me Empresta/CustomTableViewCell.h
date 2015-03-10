//
//  CustomTableViewCell.h
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/7/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import <Parse/Parse.h>

@interface CustomTableViewCell : SWTableViewCell //UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblObjetoEmprestado;
@property (weak, nonatomic) IBOutlet UILabel *lblPraQuemEmprestou;
@property (strong, nonatomic) PFObject *emprestimo;

@end
