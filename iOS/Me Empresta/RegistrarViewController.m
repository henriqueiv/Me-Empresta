//
//  RegistrarViewController.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/6/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//
#define ERRO_EMAIL_INVALIDO 125

#import "RegistrarViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "SimpleKeyChain.h"


@interface RegistrarViewController ()

@property(nonatomic, getter=isSigningUp) BOOL signingUp;
@property (strong, atomic) LoadingView *loadingView;
@property (strong, atomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UITextField *fieldUser;
@property (weak, nonatomic) IBOutlet UITextField *fieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fieldEmail;
@property (weak, nonatomic) IBOutlet UIButton *wordDown;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToBottom;
@property (weak, nonatomic) IBOutlet UIButton *btnTouchId;
@property NSMutableArray *textFields;

@end

@implementation RegistrarViewController

CGFloat _initialConstant;
static CGFloat keyboardHeightOffset = 15.0f;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self configInitialView];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)configInitialView{
    // App starts in "sing up mode"
    _signingUp = YES;
    
    // Config UITextFields
    _textFields = [[NSMutableArray alloc] initWithObjects:_fieldUser, _fieldPassword, _fieldEmail, nil];
    for (UITextField *tf in _textFields) {
        [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
        [tf setDelegate:self];
    }
    
    [_fieldUser setReturnKeyType:UIReturnKeyNext];
    
    [_fieldEmail setReturnKeyType:UIReturnKeyGo];
    
    _fieldPassword.secureTextEntry = YES;
    [_fieldPassword setReturnKeyType:UIReturnKeyNext];
    
    // Set notification to track keyboardWillShow and keyboardWillHide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Config loading view
    if(!_loadingView){
        _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    }
    //    if(!_spinner){
    //        _spinner = (UIActivityIndicatorView*)[self.view viewWithTag:12];
    //    }
    //
    //    _loadingView.center = self.view.center;
    //    [_loadingView addSubview:_spinner];
    [_loadingView setBackgroundColor:[UIColor whiteColor]];
    [_loadingView setAlpha:0.0f];
    [_loadingView setCenter:self.view.center];
    
    LAContext *context = [[LAContext alloc] init];
    
    // Test if fingerprint authentication is available on the device and a fingerprint has been enrolled.
    if ([context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]){
//        NSLog(@"Tem touch ID");
        _btnTouchId.hidden = NO;
    }else{
//        NSLog(@"Não tem touch ID");
        _btnTouchId.hidden = YES;
    }
    _btnTouchId.hidden = _signingUp;
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

- (void)configReturnKeys{
    if([self isSigningUp]){
        // If you're signin up, return in _fieldPassword will be Next
        [_fieldPassword setReturnKeyType:UIReturnKeyNext];
    }else{
        // If you're signin up, return in _fieldPassword will be Go
        [_fieldPassword setReturnKeyType:UIReturnKeyGo];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSMutableArray *validate =  _textFields;
    if ([self isSigningUp]) {
        for (UITextField *tf in validate) {
            if ([tf.text isEqualToString:@""]) {
                [tf becomeFirstResponder];
                return NO;
            }
        }
        [self signup];
    }else{
        NSLog(@"Estou loganu");
        [validate removeObject:_fieldEmail];
        for (UITextField *tf in validate) {
            if ([tf.text isEqualToString:@""] || (tf.text == NULL) || (tf.text == nil)) {
                NSLog(@"%@: %@", tf.placeholder, tf.text);
                [tf becomeFirstResponder];
                return NO;
            }
        }
        [self login];
    }
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    NSMutableArray *validate =  _textFields;
//    [validate removeObject:textField];
//    if (![self isSigningUp]) {
//        NSLog(@"Estou loganu");
//        [validate removeObject:_fieldEmail];
//    }
//    for (UITextField *tf in validate) {
//        if ([tf.text isEqualToString:@""] || (tf.text == NULL) || (tf.text == nil)) {
//            [textField setReturnKeyType:UIReturnKeyNext];
//        }
//    }
//    [textField setReturnKeyType:UIReturnKeyGo];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_fieldUser resignFirstResponder];
    [_fieldPassword resignFirstResponder];
    [_fieldEmail resignFirstResponder];
}

- (BOOL)validateUserData{
    NSMutableArray *listaCampoAValidar = _textFields;
    if(![self isSigningUp])
        [listaCampoAValidar removeObject:_fieldEmail];
    
    for (UITextField *tf in listaCampoAValidar) {
        // Validating if text fields are empty
        if ([tf.text isEqualToString:@""]) {
            [tf becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (IBAction)loginClick:(id)sender {
    _signingUp = NO;
    _btnTouchId.hidden = NO;
    _fieldEmail.hidden = ![self isSigningUp];
    [_wordDown setTitle:@"Entrar" forState:(UIControlStateNormal)];
    [self configReturnKeys];
    if([_fieldEmail isFirstResponder]){
        [_fieldEmail resignFirstResponder];
    }
    [self.view layoutIfNeeded];
}

- (IBAction)registerClick:(id)sender {
    _signingUp = YES;
    _btnTouchId.hidden = YES;
    [_fieldEmail setHidden:(![self isSigningUp])];
    [_wordDown setTitle:@"Registrar" forState:(UIControlStateNormal)];
    [self configReturnKeys];
    [self.view layoutIfNeeded];
}

- (IBAction)entrar:(id)sender{
    if([self validateUserData]){
        if([self isSigningUp]){
            [self signup];
        }else{
            [self login];
        }
    }
}

- (void)signup{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Registrando usuário...";
    [hud show:YES];
    
    PFUser *usuario = [PFUser user];
    usuario.username = _fieldUser.text;
    usuario.password = _fieldPassword.text;
    usuario.email = _fieldEmail.text;
    [usuario signUpInBackgroundWithBlock:^(BOOL	 success,	 NSError  *error){
        [hud hide:YES];
        if(success){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Bem-vindo %@", _fieldUser.text]
                                                            message:@"Usuário registrado"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self login];
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
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            break;
            
        default:
            break;
    }
    // Se colocar acao no botao do alertView e nao rolar use isso
    //[alertView.delegate alertView:alertView clickedButtonAtIndex:1];
}



- (IBAction)touchId:(id)sender{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Login using Touch ID";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        // Salva o pass no keychain
                                        NSMutableDictionary *data = [self getUserInKeyChain];
                                        if (data) {
                                            _fieldUser.text = [data objectForKey:@"user"];
                                            _fieldPassword.text = [data objectForKey:@"password"];
                                            [self login];
                                        }
                                        //                                        [self performSegueWithIdentifier:@"Success" sender:nil];
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                            message:error.description
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil, nil];
                                        [alertView show];
                                        [_fieldUser becomeFirstResponder];
                                    });
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:authError.description
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [_fieldUser becomeFirstResponder];
        });
    }
}

- (void)saveUserInKeyChain{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:[PFUser currentUser].username forKey:@"user"];
    //    [data setObject:_tfPassword.text forKey:@"password"];
    [SimpleKeychain save:@"MeEmpresta" account:@"login" data:data];
}

- (NSMutableDictionary*)getUserInKeyChain{
    NSMutableDictionary *data = NULL;
    data = [SimpleKeychain load:@"MeEmpresta" account:@"login"];
    NSLog(@"data: %@", data);
    return data;
}

- (void)login{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Logando...";
    [hud show:YES];
    
    [PFUser logInWithUsernameInBackground:_fieldUser.text password:_fieldPassword.text
                                    block:^(PFUser *user, NSError *error) {
                                        [hud hide:YES];
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
    
}

- (void)gotoApp{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"App" bundle:nil] instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
