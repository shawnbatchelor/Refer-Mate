//
//  LinkReceiveScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkReceiveScreen : UIViewController

{
    IBOutlet UILabel *savedLabel;
    IBOutlet UILabel *sharedLabel;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UIImageView *userImage;
    IBOutlet UIButton *backButton;
    IBOutlet UITextField *linkText;
}

@end
