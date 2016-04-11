//
//  SignupScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/8/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "SignupScreen.h"

@implementation SignupScreen

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
}


-(void) signupUser{
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    [ref createUser:emailText.text password:passwordText.text
withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
    
    if (error) {
        // There was an error creating the account
        NSLog(@"There was an error creating the account");
    } else {
        NSString *uid = [result objectForKey:@"uid"];
        NSLog(@"Successfully created user account with uid: %@", uid);
        [self performSegueWithIdentifier:@"segueToLogin" sender:nil];
    }
}];
}




//Actions for buttons
- (IBAction)signupAction:(id)sender {
    [self signupUser];
}

- (IBAction)cancelSignup:(id)sender {
    [self performSegueWithIdentifier:@"segueToLogin" sender:nil];
}









/*
 
 //Custom signup method
 - (void)signupParse {
 PFUser *user = [PFUser user];
 user.username = usernameText.text;
 user.password = passwordText.text;
 user.email = emailText.text;
 
 [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
 if ([usernameText.text length] <= 0 || [passwordText.text length] <= 0 || [emailText.text length] <= 0)
 {
 //Custom Alert for no email entered
 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stop!"
 message:@"You must complete all fields to signup."
 preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action) {}];
 
 [alert addAction:defaultAction];
 [self presentViewController:alert animated:YES completion:nil];
 }
 else
 {
 //Check if signup parameters are correct and load DataInput, else inform user of error
 if (!error) {
 [self performSegueWithIdentifier:@"SegueToInputs" sender:nil];
 [self resetLoginParameters];
 } else {
 errorString = [error userInfo][@"error"];
 [self generalError];
 }
 }
 }];
 }
 
 */

@end
