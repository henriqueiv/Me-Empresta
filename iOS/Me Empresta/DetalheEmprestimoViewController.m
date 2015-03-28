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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToBottom;

@end

@implementation DetalheEmprestimoViewController

CGFloat _initialConstant;
static CGFloat keyboardHeightOffset = 15.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imgView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [_imgView.layer setBorderWidth:2.0];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
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
- (void)keyboardWillShow:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (!_initialConstant) {
        _initialConstant = _constraintToBottom.constant;
    }
    // If screen can fit everything, leave the constant untouched.
    _constraintToBottom.constant = MAX(keyboardFrame.size.height + keyboardHeightOffset, _initialConstant);
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        // This method will automatically animate all views to satisfy new constants.
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Putting everything back to place.
    _constraintToBottom.constant = _initialConstant;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.tfDescricao resignFirstResponder];
    [self.tfPara resignFirstResponder];
    [self.tfDataEmprestimo resignFirstResponder];
    [self.tfDataDevolucao resignFirstResponder];
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
