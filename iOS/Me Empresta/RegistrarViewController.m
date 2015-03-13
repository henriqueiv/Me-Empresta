//
//  RegistrarViewController.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/6/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//
#define ERRO_EMAIL_INVALIDO 125

#import "RegistrarViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface RegistrarViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fieldUser;
@property (weak, nonatomic) IBOutlet UITextField *fieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fieldEmail;
@property (weak, nonatomic) IBOutlet UIButton *wordDown;
@property(nonatomic, getter=isSigningUp) BOOL signingUp;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToBottom;

@end

@implementation RegistrarViewController

CGFloat _initialConstant;
static CGFloat keyboardHeightOffset = 15.0f;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configInitialView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)configInitialView{
    self.signingUp = YES;
    _fieldUser.delegate = self;
    [_fieldUser setReturnKeyType:UIReturnKeyNext];

    _fieldEmail.delegate = self;
    [_fieldEmail setReturnKeyType:UIReturnKeyGo];
    
    _fieldPassword.delegate = self;
    _fieldPassword.secureTextEntry = YES;
    [_fieldPassword setReturnKeyType:UIReturnKeyNext];

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


-(void)configReturnKeys{
    if([self isSigningUp]){
        // Se for registro, password sera Next
        [_fieldPassword setReturnKeyType:UIReturnKeyNext];
    }else{
        // Se for login, password sera Go
        [_fieldPassword setReturnKeyType:UIReturnKeyGo];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self isSigningUp]) {
        if ([textField isEqual:_fieldUser]) {
            [_fieldPassword becomeFirstResponder];
        }else if ([textField isEqual:_fieldPassword]){
            [_fieldEmail becomeFirstResponder];
        }else if ([textField isEqual:_fieldEmail]){
            [self registrarUsuario];
        }
    }else{
        if ([textField isEqual:_fieldUser]) {
            [_fieldPassword becomeFirstResponder];
        }else if ([textField isEqual:_fieldPassword]){
            [self logarUsuario];
        }
    }
    return YES;
}

- (BOOL)dadosValidosUsuario{
    NSMutableArray *listaCampoAValidar = [[NSMutableArray alloc] initWithObjects:_fieldUser, _fieldPassword, nil];
    if(!_fieldEmail.hidden)
        [listaCampoAValidar addObject:_fieldEmail];
    
    for (UITextField *tf in listaCampoAValidar) {
        // Validando apenas se os campos estao vazios
        if ([tf.text isEqualToString:@""]) {
            [tf becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.fieldUser resignFirstResponder];
    [self.fieldPassword resignFirstResponder];
    [self.fieldEmail resignFirstResponder];
}

- (IBAction)loginClick:(id)sender {
    self.signingUp = NO;
    self.fieldEmail.hidden = ![self isSigningUp];
    [self.wordDown setTitle:@"Entrar" forState:(UIControlStateNormal)];
    [self configReturnKeys];
    [self.view layoutIfNeeded];
    if([_fieldEmail isFirstResponder]){
        [_fieldEmail resignFirstResponder];
    }
}

- (IBAction)registerClick:(id)sender {
    self.signingUp = YES;
    self.fieldEmail.hidden = ![self isSigningUp];
    [self.wordDown setTitle:@"Registrar" forState:(UIControlStateNormal)];
    [self configReturnKeys];
    [self.view layoutIfNeeded];
}

- (void)registrarUsuario{
    if([self dadosValidosUsuario]){
        [_spinner startAnimating];
        
        PFUser *usuario = [PFUser user];
        usuario.username = _fieldUser.text;
        usuario.password = _fieldPassword.text;
        usuario.email = _fieldEmail.text;
        [usuario signUpInBackgroundWithBlock:^(BOOL	 success,	 NSError  *error){
            UIActivityIndicatorView *spinner = (UIActivityIndicatorView*)[self.view viewWithTag:12];
            [spinner stopAnimating];
            if(success){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Bem-vindo %@", _fieldUser.text]
                                                                message:@"Usuário registrado"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [self logarUsuario];
            }else{
                NSString *erro = [[NSString alloc] init];
                erro = [NSString stringWithFormat:@"%ld", (long)error.code];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro ao registrar usuário"
                                                                message:NSLocalizedString(erro, nil)
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                switch (error.code) {
                    case ERRO_EMAIL_INVALIDO:
                        [_fieldEmail becomeFirstResponder];
                        [_fieldEmail selectAll:nil];
                        break;
                        
                    default:
                        break;
                }
            }
        }];
        [_spinner stopAnimating];
    }
}

-(IBAction)entrar:(id)sender{
    if([self isSigningUp]){
        [self registrarUsuario];
    }else{
        [self logarUsuario];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    // Se colocar acao no botao do alertView e nao rolar use isso
    //[alertView.delegate alertView:alertView clickedButtonAtIndex:1];
}

- (void)logarUsuario{
    if([self dadosValidosUsuario]){
//        [_spinner startAnimating];
        [PFUser logInWithUsernameInBackground:_fieldUser.text password:_fieldPassword.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                [self gotoApp];
                                            } else {
                                                NSString *erro = [[NSString alloc] init];
                                                erro = [NSString stringWithFormat:@"%ld", (long)error.code];
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro ao logar"
                                                                                                message:NSLocalizedString(erro, nil)
                                                                                               delegate:self
                                                                                      cancelButtonTitle:@"OK"
                                                                                      otherButtonTitles:nil];
                                                [alert show];
                                            }
                                        }];
        
//        [_spinner stopAnimating];
    }
    
}

-(void)gotoApp{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"App" bundle:nil] instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
