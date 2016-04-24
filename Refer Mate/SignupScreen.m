//
//  SignupScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/8/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "SignupScreen.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "SettingsScreen.h"



@implementation SignupScreen

CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;
NSString *zipCode;
NSString *city;



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
        uid = [result objectForKey:@"uid"];
        [self logUser];
        
        //Signup successful
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Hooray!"
                                                                       message:@"Your signup was successful. We'll log you in automatically."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  
                                                                  [ref authUser:emailText.text password:passwordText.text
                                                            withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                                
                                                                if (error) {
                                                                    [self invalidAccountAlert];
                                                                } else {
                                                                    [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
                                                                }
                                                            }];
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
//        SettingsScreen * checkAutoLogon = [[SettingsScreen alloc] init];
//        checkAutoLogon.autoLogonCheckState = true;
    }
}];
    }
    
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Actions for buttons
- (IBAction)signupAction:(id)sender {
    if (![self connected])
    {
        [self noInternetAlert];
    } else {
        [self signupUser];
    }
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

//Check Internet connection
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

//No Internet Alert
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





/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Create user entry into Firebase database
-(void)logUser{
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    NSDictionary *usersDictionary = @{
                                      @"firstname" : firstnameText.text,
                                      @"lastname" : lastnameText.text,
                                      @"displayName" : usernameText.text,
                                      @"email" : emailText.text,
                                      @"zip_code" : zipCode
                                      };
    Firebase *usersRef = [ref childByAppendingPath: @"users"];
    Firebase *setUser = [usersRef childByAppendingPath: uid];//usernameText.text];
    [setUser setValue: usersDictionary];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Get users location for reverse zip code, city lookup
- (void)getCurrentLocation{
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        NSLog(@"Location services ARE enabled");
        
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        [self alertForNoGeolocation];
    } else {
        NSLog(@"Location services are NOT enabled");
        [self.locationManager requestWhenInUseAuthorization];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    // Reverse Geocoding city and zip code
    NSLog(@"Resolving the Address");
    geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            zipCode = [NSString stringWithFormat:@"%@",placemark.postalCode];
            NSLog(@"Zip Code is %.@", zipCode);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    // Stop Location Manager
    [self.locationManager stopUpdatingLocation];
}





-(void)alertForNoGeolocation{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Location Required!"
                                                                   message:@"Looks like your location service is not enabled. We need your location in order to provide you with location specific referrals."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Enter Zip Code", @"ZipCode");
         textField.keyboardType = UIKeyboardTypeNumberPad;
         [textField addTarget:self
                       action:@selector(alertTextFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
     }];
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    defaultAction.enabled = NO;
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    if (alert)
    {
        UITextField *zipField = alert.textFields.firstObject;
        UIAlertAction *defaultAction = alert.actions.lastObject;
        defaultAction.enabled = zipField.text.length == 5;
        zipCode = zipField.text;
        NSLog(@"Zip Code is %.@", zipCode);
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self getCurrentLocation];
}


@end
