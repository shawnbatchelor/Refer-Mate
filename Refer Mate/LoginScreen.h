//
//  LoginScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/7/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <Social/Social.h>

@interface LoginScreen : UIViewController 

{
    IBOutlet UITextField *emailText;
    IBOutlet UITextField *passwordText;
    IBOutlet UIButton *signupButton;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *forgotButton;
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UISwitch *rememberSwitch;
    NSString *errorString;
    NSString *userID;

}


@end
