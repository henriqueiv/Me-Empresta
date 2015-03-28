//
//  SettingsViewController.m
//  Me Empresta
//
//  Created by Henrique Valcanaia on 3/15/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

#import "SettingsViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Parse/Parse.h>
#import "SimpleKeyChain.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnEnableDisableTouchId;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tfUsername.text = [PFUser currentUser].username;
    NSMutableDictionary *data = [self getUserInKeyChain];
    if(data != nil){
        if(![[PFUser currentUser].username isEqualToString:[data objectForKey:@"user"]]){
            _btnEnableDisableTouchId.enabled = NO;
            _tfPassword.enabled = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                message:[NSString stringWithFormat:@"O Touch ID deste telefone já está sendo utilizado pelo usuario '%@'!", [data objectForKey:@"user"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            [_btnEnableDisableTouchId setTitle:@"Disable Touch ID" forState:UIControlStateNormal];
        }
    }else{
        [_btnEnableDisableTouchId setTitle:@"Enable Touch ID" forState:UIControlStateNormal];
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(unwind)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)unwind{
    [self performSegueWithIdentifier:@"unwindSegueTouchId" sender:self];
}

- (IBAction)enableDisableTouchId:(id)sender{
    if ([_tfPassword.text isEqualToString:@""]) {
        [_tfPassword becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"To do this you must confirm your password!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        if([PFUser logInWithUsername:[PFUser currentUser].username password:_tfPassword.text]){
            if([self getUserInKeyChain]){
                LAContext *myContext = [[LAContext alloc] init];
                NSError *authError = nil;
                NSString *myLocalizedReasonString = @"Touch ID for app login";
                
                if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
                    [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                              localizedReason:myLocalizedReasonString
                                        reply:^(BOOL success, NSError *error) {
                                            if (success) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [SimpleKeychain delete:@"MeEmpresta" account:@"login"];
                                                    _tfPassword.text = @"";
                                                    [_btnEnableDisableTouchId setTitle:@"Enable Touch ID" forState:UIControlStateNormal];
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                                        message:@"Touch ID successfully disabled!"
                                                                                                       delegate:self
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil, nil];
                                                    [alertView show];
                                                });
                                            } else {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                        message:error.description
                                                                                                       delegate:self
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil, nil];
                                                    [alertView show];
                                                    // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
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
                    });
                }
            }else{
                LAContext *myContext = [[LAContext alloc] init];
                NSError *authError = nil;
                NSString *myLocalizedReasonString = @"Touch ID for app login";
                
                if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
                    [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                              localizedReason:myLocalizedReasonString
                                        reply:^(BOOL success, NSError *error) {
                                            if (success) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self saveUserInKeyChain];
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                                        message:@"Touch ID successfully enabled!"
                                                                                                       delegate:self
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil, nil];
                                                    [alertView show];
                                                    _tfPassword.text = @"";
                                                    [_btnEnableDisableTouchId setTitle:@"Disable Touch ID" forState:UIControlStateNormal];
                                                });
                                            } else {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                        message:error.description
                                                                                                       delegate:self
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil, nil];
                                                    [alertView show];
                                                    // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
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
                    });
                }
            }
        }else{
            [_tfPassword becomeFirstResponder];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Wrong password!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (IBAction)login:(id)sender{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Touch ID Test to show Touch ID working in a custom app";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self getUserInKeyChain];
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                            message:error.description
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil, nil];
                                        [alertView show];
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
            // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
        });
    }
}

- (void)saveUserInKeyChain{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:[PFUser currentUser].username forKey:@"user"];
    [data setObject:_tfPassword.text forKey:@"password"];
    [SimpleKeychain save:@"MeEmpresta" account:@"login" data:data];
}

- (NSMutableDictionary*)getUserInKeyChain{
    NSMutableDictionary *data = NULL;
    data = [SimpleKeychain load:@"MeEmpresta" account:@"login"];
//    NSLog(@"data: %@", data);
    return data;
}

@end
