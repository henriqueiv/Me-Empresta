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
#define SWIPE_CELL_LEFT_SETTLE_BUTTON 0

@interface EmprestimosViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *btnAdd;
@property (weak, nonatomic) IBOutlet UIImageView *btnLogout;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *emprestimos;

@end

@implementation EmprestimosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    
    [self loadData];
    
    UITapGestureRecognizer *tapAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdd)];
    [tapAdd setNumberOfTapsRequired:1];
    [_btnAdd addGestureRecognizer:tapAdd];
    
//    UITapGestureRecognizer *tapRefresh = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshTable)];
//    [tapRefresh setNumberOfTapsRequired:1];
//    [_btnRefresh addGestureRecognizer:tapRefresh];
    
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

-(void)refreshTable{
    [self loadData];
    [self.tableView reloadData];
    [_refreshControl endRefreshing];
}

-(void)loadData{
    NSError *erro;
    PFQuery *query = [PFQuery queryWithClassName:@"Emprestimo"];
    NSString *username = [[PFUser currentUser] username];
    
    [query whereKey:@"de" equalTo:username];
    [query whereKey:@"devolvido" equalTo:[NSNumber numberWithBool:NO]];
    _emprestimos = [query findObjects:&erro];
    if (erro) {
        NSLog(@"Erro: %@", erro);
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _emprestimos.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Section: %ld", section];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Cinza escuro: 62,65,72
    // Amarelo claro: 255, 252, 179
    UIColor *cinza = [UIColor colorWithRed:255.0f/255
                                     green:252.0f/255
                                      blue:179.0f/255
                                     alpha:1.0f];

    UIColor *amarelo = [UIColor colorWithRed:255.0f/255
                                     green:252.0f/255
                                      blue:179.0f/255
                                     alpha:1.0f];
    
    
    cell.backgroundColor = cinza;
    
    [cell.textLabel setBackgroundColor:cell.backgroundColor];
    [cell.detailTextLabel setBackgroundColor:cell.backgroundColor];
    
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
}

-(UIColor*)invertColor:(UIColor*)baseColor{
    CGFloat r, g, b, a;
    [baseColor getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"emprestimoCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *o = _emprestimos[indexPath.row];
    
    cell.textLabel.text = [o objectForKey:@"descricao"];
    cell.detailTextLabel.text = [o objectForKey:@"para"];
    PFFile *eventImage = [o objectForKey:@"imagem"];
    if(eventImage != NULL){
        [eventImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                UIImage *thumbnailImage = [UIImage imageWithData:imageData];
                cell.imageView.image = thumbnailImage;
            });
        }];
    }
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed:198.0f/255.0f
                                                                       green:33.0f/255.0f
                                                                        blue:37.0f/255.0f
                                                                       alpha:1.0f]
                                                title:@"Excluir"];
    
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed:46/255.0f
                                                                      green:165.0f/255.0f
                                                                       blue:27.0f/255.0f
                                                                      alpha:1.0f]
                                               title:@"Devolvido"];
    cell.delegate = self;
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.leftUtilityButtons = leftUtilityButtons;
    cell.emprestimo = o;
//    NSLog(@"%@", cell);
    
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
            
            dvc.imagem = cell.imageView.image;
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
    if([segue.identifier isEqualToString:@"showDetail"]){
        [self loadData];
    }else if ([segue.identifier isEqualToString:@"touchId"]){
        // Do nothing
    }
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

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
    switch (index) {
        case SWIPE_CELL_LEFT_SETTLE_BUTTON:{
            CustomTableViewCell *customCell = (CustomTableViewCell*) cell;
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [customCell.emprestimo setValue:[NSNumber numberWithBool:YES] forKey:@"devolvido"];
            [customCell.emprestimo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [_emprestimos removeObjectAtIndex:cellIndexPath.row];
                        [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                        //NSLog(@"%@", customCell.emprestimo);
                    });
                }else{
                    NSLog(@"Erro ao devolver objeto!");
                }
            }];
            break;
        }
            
        default:
            break;
    }
}

@end
