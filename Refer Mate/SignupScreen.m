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
    
    if([emailText.text length] == 0 || emailText.text == nil ||
       [firstnameText.text length] == 0 || firstnameText.text == nil ||
       [lastnameText.text length] == 0 || lastnameText.text == nil ||
       [usernameText.text length] == 0 || usernameText.text == nil ||
       [passwordText.text length] == 0 || passwordText.text == nil ||
       [passwordConfirm.text length] == 0 || passwordConfirm.text == nil)
    {
        //All fields are not completed
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stop!"
                                                                       message:@"You must complete all fields before continuing."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (![self validateEmail:[emailText text]]) {
        //User entered invalid email address
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                       message:@"Please enter an email address in the format xx@yy.zzz."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (passwordText.text != passwordConfirm.text){
        //Password and password confirmation do not match
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                       message:@"Your password and password confirmation do not match. Please retype them and try again."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
        [ref createUser:emailText.text password:passwordText.text
withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
    
    if (error) {
        //Couldn't create that account
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                       message:@"We couldn't create the account for you. Please try again later."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        NSString *uid = [result objectForKey:@"uid"];
        NSLog(@"Successfully created user account with uid: %@", uid);
        [self performSegueWithIdentifier:@"segueToLogin" sender:nil];
    }
}];
    }
    
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Actions for buttons
- (IBAction)signupAction:(id)sender {
    [self signupUser];
}

- (IBAction)cancelSignup:(id)sender {
    [self performSegueWithIdentifier:@"segueToLogin" sender:nil];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Dismiss keyboard on tap
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//Validate correct email address format
- (BOOL)validateEmail:(NSString *)emailAddr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *checkEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [checkEmail evaluateWithObject:emailAddr];
}

@end
