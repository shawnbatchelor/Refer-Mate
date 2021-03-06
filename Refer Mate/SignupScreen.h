//
//  SignupScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/8/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <CoreLocation/CoreLocation.h>

@interface SignupScreen : UIViewController<CLLocationManagerDelegate>

{
    IBOutlet UITextField *usernameText;
    IBOutlet UITextField *passwordText;
    IBOutlet UITextField *passwordConfirm;
    IBOutlet UITextField *firstnameText;
    IBOutlet UITextField *lastnameText;
    IBOutlet UITextField *emailText;

    IBOutlet UIButton *signupButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UISwitch *rememberSwitch;
    NSString *errorString;
    NSString *uid;
}
@property(nonatomic)CLLocationManager *locationManager;



@end
