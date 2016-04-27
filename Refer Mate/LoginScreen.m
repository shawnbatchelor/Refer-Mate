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
#import "UserProfileScreen.h"
#import "AppDelegate.h"
#import "SettingsScreen.h"


@implementation LoginScreen

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    long autoLogonState = [prefs integerForKey:@"autoLogin"];
    
    if (![self connected])
    {
        [self noInternetAlert];
    } else {
        if (autoLogonState == 1){
            [self checkUserAuth];
        }
    }
}



//Manual Authenticaon
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
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"] == 1){
            [self saveSettings];
        }
        userID = authData.uid;
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.authenticatedUser = userID;
        [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
    }
}];
    
}



//Facebook Authentication
-(void)facebookUserAuth {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    
    [facebookLogin logInWithReadPermissions:@[@"email"] fromViewController:self
                                    handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError){
                                        
                                        if (facebookError) {
                                            [self facebookFailAlert];
                                        } else if (facebookResult.isCancelled) {
                                            [self facebookFailAlert];
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            
                                            [ref authWithOAuthProvider:@"facebook" token:accessToken
                                                   withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                       
                                                       if (error) {
                                                           [self facebookFailAlert];
                                                       } else {
                                                           usersDictionary = @{
                                                                               @"fullname" : [authData.providerData objectForKey:@"displayName"],
                                                                               @"displayName" : [authData.providerData objectForKey:@"id"],
                                                                               @"email" : [authData.providerData objectForKey:@"email"],
                                                                               @"providerPicURL" : [authData.providerData objectForKey:@"profileImageURL"]
                                                                               };
                                                           
                                                           userID = authData.uid;
                                                           AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                                           appDelegate.authenticatedUser = userID;
                                                           [self logProviderUser];
                                                           [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
                                                           if ([[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"] == 1){
                                                               [self saveSettings];
                                                           }                                                       }
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
            [self twitterFailAlert];
        } else if ([accounts count] == 0) {
            [self twitterFailAlert];
        } else {
            // Select an account. Here we pick the first one for simplicity
            ACAccount *account = [accounts firstObject];
            [twitterAuthHelper authenticateAccount:account withCallback:^(NSError *error, FAuthData *authData) {
                if (error) {
                    [self twitterFailAlert];
                } else {
                    usersDictionary = @{
                                        @"fullname" : [authData.providerData objectForKey:@"displayName"],
                                        @"displayName" : [authData.providerData objectForKey:@"username"],
                                        @"email" : [authData.providerData objectForKey:@"id"],
                                        @"providerPicURL" : [authData.providerData objectForKey:@"profileImageURL"]
                                        };
                    userID = authData.uid;
                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    appDelegate.authenticatedUser = userID;
                    [self logProviderUser];
                    [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"] == 1){
                        [self saveSettings];
                    }                }
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

//Check if user is already logged in for this session
-(void)checkUserAuth{
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    
    if (ref.authData) {
        // user authenticated
        userID = ref.authData.uid;
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.authenticatedUser = userID;
        [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
    } else {
        // No user is signed in
    }
}

-(void)logProviderUser{
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    Firebase *usersRef = [ref childByAppendingPath: @"users"];
    Firebase *setUser = [usersRef childByAppendingPath: userID];
    [setUser setValue: usersDictionary];
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



-(void)saveSettings{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1 forKey:@"autoLogin"];
    [prefs synchronize];
}
@end
