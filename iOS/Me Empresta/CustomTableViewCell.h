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

@property (strong, nonatomic) PFObject *emprestimo;

@end
