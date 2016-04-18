//
//  LinkSubmitScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <Social/Social.h>


@interface LinkSubmitScreen : UIViewController

{
    IBOutlet UIButton *submitButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *backButton;
    IBOutlet UITextField *linkText;
    NSString *userAutoID;
    NSDictionary *linkDictionary;
}

@property(nonatomic, strong)NSString *toProgramLabelSegueString;

@end
