//
//  EmprestimosTableViewController.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/4/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import "EmprestimosViewController.h"
#import "CustomTableViewCell.h"
#import "DetalheEmprestimoViewController.h"
#import <Parse/Parse.h>

#define SWIPE_CELL_RIGHT_DELETE_BUTTON 0

@interface EmprestimosViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *btnAdd;
@property (weak, nonatomic) IBOutlet UIImageView *btnRefresh;
@property (weak, nonatomic) IBOutlet UIImageView *btnLogout;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *emprestimos;

@end

@implementation EmprestimosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    UITapGestureRecognizer *tapAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdd)];
    [tapAdd setNumberOfTapsRequired:1];
    [_btnAdd addGestureRecognizer:tapAdd];
    
    UITapGestureRecognizer *tapRefresh = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRefresh)];
    [tapRefresh setNumberOfTapsRequired:1];
    [_btnRefresh addGestureRecognizer:tapRefresh];
    
    UITapGestureRecognizer *tapLogout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogout)];
    [tapLogout setNumberOfTapsRequired:1];
    [_btnLogout addGestureRecognizer:tapLogout];    
    
    // Caso user interaction esteja desativado no IB descomentar abaixo
    //[_imageView setUserInteractionEnabled:YES];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

-(void)tapAdd{
    [self performSegueWithIdentifier:@"showDetail" sender:_btnAdd];
}

-(void)tapLogout{
    [self logout];
}

-(void)tapRefresh{
    [self loadData];
}

-(void)loadData{
    NSError *erro;
    PFQuery *query = [PFQuery queryWithClassName:@"Emprestimo"];
    NSString *username = [[PFUser currentUser] username];
    
    [query whereKey:@"de" equalTo:username];
    _emprestimos = [query findObjects:&erro];
    if (erro) {
        NSLog(@"Erro: %@", erro);
    }
    [_tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _emprestimos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"emprestimoCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *o = _emprestimos[indexPath.row];

    cell.lblPraQuemEmprestou.text = [o objectForKey:@"para"];
    cell.lblObjetoEmprestado.text = [o objectForKey:@"descricao"];
    PFFile *eventImage = [o objectForKey:@"imagem"];
    if(eventImage != NULL){
        [eventImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                UIImage *thumbnailImage = [UIImage imageWithData:imageData];
                cell.imgView.image = thumbnailImage;
                
            });
        }];
    }
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed:1.0f
                                                                       green:0.231f
                                                                        blue:0.188
                                                                       alpha:1.0f]
                                                title:@"Excluir"];
    cell.delegate = self;
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.emprestimo = o;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"]){
        DetalheEmprestimoViewController *dvc = (DetalheEmprestimoViewController*) segue.destinationViewController;
        if ([NSStringFromClass([sender class]) isEqualToString:NSStringFromClass([NSIndexPath class])]) {
            NSIndexPath *indexPath = (NSIndexPath*) sender;
            CustomTableViewCell *cell = (CustomTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
            
            dvc.imagem = cell.imgView.image;
            dvc.emprestimo = _emprestimos[indexPath.row];
            dvc.editing = YES;
        }else if ([sender isEqual:_btnAdd]){
            dvc.editing = NO;
        }
    }
}

-(void)logout{
    [PFUser logOut];
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    [self loadData];
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    switch (index) {
        case SWIPE_CELL_RIGHT_DELETE_BUTTON:{
            CustomTableViewCell *customCell = (CustomTableViewCell*) cell;
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];

            [customCell.emprestimo deleteInBackground];
            [_emprestimos removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
            
        default:
            break;
    }
}

@end
