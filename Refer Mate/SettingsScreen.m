//
//  SettingsScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/22/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "SettingsScreen.h"
#import <Firebase/Firebase.h>
//#import "LoginScreen.h"

@implementation SettingsScreen

CLLocationManager *locationManager;

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    long autoLogonState = [prefs integerForKey:@"autoLogin"];
    long geoLocateState = [prefs integerForKey:@"geoState"];

    //Remember autoLogon state
    if (autoLogonState == 1){
        [autoLogonSwitch setOn:YES];
    }else if (autoLogonState == 0){
        [autoLogonSwitch setOn:NO];
    }
    
    //Remember  geolocate state
    if (geoLocateState == 1){
        [geolocationSwitch setOn:YES];
    }else if (geoLocateState == 0){
        [geolocationSwitch setOn:NO];
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Geolocation action
-(IBAction)geolocationToggle{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //If the switch is off
    if(![geolocationSwitch isOn]){
        [self.locationManager stopUpdatingLocation];
        [prefs setInteger:0 forKey:@"geoState"];
        [prefs synchronize];
        
    //If the switch is on
    }else if ([geolocationSwitch isOn]){
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
            [self.locationManager startUpdatingLocation];
        }
        [prefs setInteger:1 forKey:@"geoState"];
        [prefs synchronize];
    }
}


//Autologon action
-(IBAction)autoLogonToggle{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([autoLogonSwitch isOn]){
        [prefs setInteger:1 forKey:@"autoLogin"];
        [prefs synchronize];
    }else if (![autoLogonSwitch isOn]){
        [prefs setInteger:0 forKey:@"autoLogin"];
        [prefs synchronize];
    }
}

//Load program action
-(IBAction)loadPrograms{
    [self performSegueWithIdentifier:@"goToPrograms" sender:nil];
}

@end
