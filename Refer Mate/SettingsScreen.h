//
//  SettingsScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/22/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>



@interface SettingsScreen : UIViewController<CLLocationManagerDelegate>
{
    IBOutlet UIButton *closeButton;
    IBOutlet UISwitch *geolocationSwitch;
    IBOutlet UISwitch *autoLogonSwitch;
}

@property(nonatomic)CLLocationManager *settingsLocationManager;

@end
