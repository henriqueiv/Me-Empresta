//
//  DetalheEmprestimoViewController.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/9/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import "DetalheEmprestimoViewController.h"
#import "EmprestimosViewController.h"

@interface DetalheEmprestimoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfDescricao;
@property (weak, nonatomic) IBOutlet UITextField *tfPara;
@property (weak, nonatomic) IBOutlet UITextField *tfDataEmprestimo;
@property (weak, nonatomic) IBOutlet UITextField *tfDataDevolucao;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation DetalheEmprestimoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imgView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [_imgView.layer setBorderWidth:2.0];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM, yyyy"];
    if (_editing) {
        _tfDescricao.text = [_emprestimo objectForKey:@"descricao"];
        _tfPara.text = [_emprestimo objectForKey:@"para"];
        _tfDataEmprestimo.text = [format stringFromDate:[_emprestimo objectForKey:@"dataEmprestimo"]];
        _tfDataDevolucao.text = [format stringFromDate:[_emprestimo objectForKey:@"dataDevolucao"]];
        _imgView.image = _imagem;
    }else{
        _tfDataEmprestimo.text = [format stringFromDate:[NSDate date]];
        _tfDataDevolucao.text = [format stringFromDate:[NSDate date]];
        [_tfDescricao becomeFirstResponder];
    }
}

-(IBAction)finishEditing:(id)sender{
    PFObject *emprestimo;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM, yyyy"];
    
    if (_editing) {
        PFQuery *query = [PFQuery queryWithClassName:@"Emprestimo"];
        emprestimo = [query getObjectWithId:_emprestimo.objectId];
    }else{
        emprestimo = [PFObject objectWithClassName:@"Emprestimo"];
        emprestimo[@"devolvido"] = [NSNumber numberWithBool:NO];
    }
    
    emprestimo[@"de"] = [PFUser currentUser].username;
    emprestimo[@"para"] = _tfPara.text;
    emprestimo[@"descricao"] = _tfDescricao.text;
    emprestimo[@"dataDevolucao"] = [format dateFromString:_tfDataDevolucao.text];
    emprestimo[@"dataEmprestimo"] = [format dateFromString:_tfDataEmprestimo.text];
    if ([emprestimo save]) {
        [self performSegueWithIdentifier:@"unwindSegue" sender:self];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro"
                                                        message:@"Erro ao salvar!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


@end
