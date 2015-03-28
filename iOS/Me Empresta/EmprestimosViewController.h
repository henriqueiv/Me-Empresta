//
//  EmprestimosTableViewController.h
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/4/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface EmprestimosViewController : UIViewController <SWTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

- (void)loadData;

@end
