//
//  LoginViewController.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/4/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fieldUsuario;
@property (weak, nonatomic) IBOutlet UITextField *fieldSenha;
@property NSArray *exerciciosArray;

@end

@implementation LoginViewController


- (BOOL)dadosValidosUsuario{
    NSMutableArray *listaCampoAValidar = [[NSMutableArray alloc] initWithObjects:_fieldUsuario, _fieldSenha, nil];
    for (UITextField *tf in listaCampoAValidar) {
        // Validando apenas se os campos estao vazios
        if ([tf.text isEqualToString:@""]) {
            [tf becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (IBAction)logarUsuario:(id)sender{
    if([self dadosValidosUsuario]){
        NSLog(@"Logando...");
        [PFUser logInWithUsernameInBackground:_fieldUsuario.text password:_fieldSenha.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                NSLog(@"Logado!");
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
        
    }else{
        NSLog(@"Dados invalidos");
    }
}

-(void)gotoApp{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"App" bundle:nil] instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [_fieldUsuario becomeFirstResponder];
    }
    // Se colocar acao no botao do alertView e nao rolar use isso
    //[alertView.delegate alertView:alertView clickedButtonAtIndex:1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_fieldUsuario]) {
        [textField resignFirstResponder];
        [_fieldSenha becomeFirstResponder];
    }else if ([textField isEqual:_fieldSenha]){
        [self logarUsuario:nil];
    }
    return YES;
}

//- (IBAction)registrarUsuario:(id)sender{
//    if([self dadosValidosUsuario]){
//        PFUser *usuario = [PFUser user];
//        usuario.username = _fieldUser.text;
//        usuario.password = _fieldPassword.text;
//        usuario.email = _fieldEmail.text;
//        [usuario signUpInBackgroundWithBlock:^(BOOL	 success,	 NSError  *error){
//            if(success){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Bem-vindo %@", _fieldUser.text]
//                                                                message:@"Usuário registrado"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//                [self logarUsuario:nil];
//            }else{
//                NSString *erro = [[NSString alloc] init];
//                erro = [NSString stringWithFormat:@"%ld", (long)error.code];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro ao registrar usuário"
//                                                                message:NSLocalizedString(erro, nil)
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//                
//                switch (error.code) {
//                    case ERRO_EMAIL_INVALIDO:
//                        [_fieldEmail becomeFirstResponder];
//                        [_fieldEmail selectAll:nil];
//                        break;
//                        
//                    default:
//                        break;
//                }
//            }
//        }];
//    }
//}


@end
