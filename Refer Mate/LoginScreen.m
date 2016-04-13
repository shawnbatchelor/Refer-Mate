//
//  LoginScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/7/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "LoginScreen.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TwitterAuthHelper.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"


@implementation LoginScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}



//Manual Authentication
- (void)loginUser {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    [ref authUser:emailText.text password:passwordText.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
    if (error) {
        //Check textfield contents
        if([emailText.text length] == 0 || emailText.text == nil || ![self validateEmail:[emailText text]])
        {
            [self invalidEmailAlert];
        }
        else
        {
            [self invalidAccountAlert];
        }
    } else {
        // We are now logged in
        [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
    }
}];
    
}



//Facebook Authentication
-(void)facebookUserAuth {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    [facebookLogin logInWithReadPermissions:@[@"email"]
                                    handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
                                        
                                        if (facebookError) {
                                           // NSLog(@"Facebook login failed. Error: %@", facebookError);
                                            [self facebookFailAlert];
                                        } else if (facebookResult.isCancelled) {
                                            //NSLog(@"Facebook login got cancelled.");
                                            [self facebookFailAlert];
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            
                                            [ref authWithOAuthProvider:@"facebook" token:accessToken
                                                   withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                       
                                                       if (error) {
                                                           //NSLog(@"Login failed. %@", error);
                                                           [self facebookFailAlert];
                                                       } else {
                                                           [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
                                                       }
                                                   }];
                                        }
                                    }];
}



//Twitter Authentication
-(void)twitterUserAuth {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    TwitterAuthHelper *twitterAuthHelper = [[TwitterAuthHelper alloc] initWithFirebaseRef:ref
                                                                                   apiKey:@"iKUxdxzv2SQJzxt1VM5aJzzAH"];
    [twitterAuthHelper selectTwitterAccountWithCallback:^(NSError *error, NSArray *accounts) {
        if (error) {
            //NSLog(@"Error retrieving Twitter accounts");
            [self twitterFailAlert];
        } else if ([accounts count] == 0) {
            //NSLog(@"No Twitter accounts found on device");
            [self twitterFailAlert];
        } else {
            // Select an account. Here we pick the first one for simplicity
            ACAccount *account = [accounts firstObject];
            [twitterAuthHelper authenticateAccount:account withCallback:^(NSError *error, FAuthData *authData) {
                if (error) {
                    //NSLog(@"Error authenticating account");
                    [self twitterFailAlert];
                } else {
                    [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
                }
            }];
        }
    }];
}



//Password Reset
-(void)resetUser {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    [ref resetPasswordForUser:emailText.text withCompletionBlock:^(NSError *error) {
        if (error) {
            //Check textfield contents
            if([emailText.text length] == 0 || emailText.text == nil || ![self validateEmail:[emailText text]])
            {
                [self invalidEmailAlert];
            } else {
                [self invalidAccountAlert];
            }
            
        } else {
            //NSLog(@"We sent an email with reset instructions.");
            // Password reset sent successfully
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success!"
                                                                           message:@"We sent an email to your address on file. Please follow the instructions in order to reset your password."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Actions for buttons
- (IBAction)loadSignupScreen:(id)sender {
    [self performSegueWithIdentifier:@"segueToSignup" sender:nil];
}

- (IBAction)loginAction:(id)sender {
    if (![self connected])
    {
        [self noInternetAlert];
    } else {
        [self loginUser];
    }
}

- (IBAction)facebookLogin:(id)sender {
    if (![self connected])
    {
        [self noInternetAlert];
    } else {
        [self facebookUserAuth];
    }
}

- (IBAction)twitterLogin:(id)sender {
    if (![self connected])
    {
        [self noInternetAlert];
    } else {
        [self twitterUserAuth];
    }
}

- (IBAction)resetPassword:(id)sender {
    if (![self connected])
    {
        [self noInternetAlert];
    } else {
        [self resetUser];
    }
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

//Check Internet connection
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Custom alerts
-(void) invalidEmailAlert {
    //User intered invalid email address
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                   message:@"Please enter an email address in the format xx@yy.zzz."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) invalidAccountAlert {
    //Couldn't find that account
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                   message:@"We couldn't find an account with the email address provided. Please retype your email address or try creating a new account."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) facebookFailAlert {
    //Couldn't find that account
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                   message:@"We couldn't log you in using your Facebook credentials. Please try again or use another login method."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) twitterFailAlert {
    //Couldn't find that account
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                   message:@"We couldn't log you in using your Twitter credentials. Please try again or use another login method."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) noInternetAlert {
    //Not connected to the Intenet
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                   message:@"Looks like you have no Internet connection. Connect and try again"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}




@end
