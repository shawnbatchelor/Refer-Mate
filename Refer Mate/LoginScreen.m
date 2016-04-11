//
//  LoginScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/7/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "LoginScreen.h"

@implementation LoginScreen

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
}




- (void)loginUser {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    [ref authUser:emailText.text password:passwordText.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
    if (error) {
        // There was an error logging in to this account
        NSLog(@"There was an logging in to this account");
    } else {
        // We are now logged in
        [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
    }
}];
    
}



//Actions for buttons
- (IBAction)loginAction:(id)sender {
    [self loginUser];
}

- (IBAction)loadSignupScreen:(id)sender {
    [self performSegueWithIdentifier:@"segueToSignup" sender:nil];
}


/*
 
 
 //Custom login method
 - (void)loginParse {
 [PFUser logInWithUsernameInBackground:usernameText.text password:passwordText.text
 block:^(PFUser *user, NSError *error) {
 if ([usernameText.text length] <= 0 || [passwordText.text length] <= 0)
 {
 //Custom Alert for no email entered
 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stop!"
 message:@"You must enter both a username and password to log in."
 preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action) {}];
 
 [alert addAction:defaultAction];
 [self presentViewController:alert animated:YES completion:nil];
 }
 else
 {
 //Check if user parameters are correct and load DataInput, else inform user of error
 if (user) {
 [self performSegueWithIdentifier:@"SegueToInputs" sender:nil];
 [self resetLoginParameters];
 } else {
 errorString = [error userInfo][@"error"];
 [self generalError];
 }
 }
 }];
 }
 
 
 //Generate Error Alert with custom message from server error
 - (void) generalError {
 //Error alert with error string
 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stop!"
 message:errorString
 preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action) {}];
 
 [alert addAction:defaultAction];
 [self presentViewController:alert animated:YES completion:nil];
 }
 
 
 //Actions for buttons
 - (IBAction)signupAction:(id)sender {
 [self signupParse];
 }
 
 - (IBAction)loginAction:(id)sender {
 [self loginParse];
 }
 
 - (IBAction)forgotAction:(id)sender {
 
 if ([emailText.text length] > 0)
 {
 [PFUser requestPasswordResetForEmailInBackground:emailText.text];
 }
 else
 {
 //Custom Alert for no email entered
 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stop!"
 message:@"Please enter your email address in order to reset your password."
 preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action) {}];
 
 [alert addAction:defaultAction];
 [self presentViewController:alert animated:YES completion:nil];
 }
 }
 
 
 - (IBAction)logoutAction:(UIStoryboardSegue *)unwinder {
 [PFUser logOut];
 //PFUser *currentUser = [PFUser currentUser];
 }
 
 - (void) resetLoginParameters {
 usernameText.text = @"";
 usernameText.text = @"";
 usernameText.text = @"";
 }
 */



@end
