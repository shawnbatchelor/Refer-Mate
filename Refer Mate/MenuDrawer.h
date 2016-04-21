//
//  MenuDrawer.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/21/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface MenuDrawer : UIViewController

{
    IBOutlet UIView *menuView;
    IBOutlet UIViewController *clearView;
    IBOutlet UIButton *settingsButton;
    IBOutlet UIButton *helpButton;
    IBOutlet UIButton *privacyButton;
    IBOutlet UIButton *logoutButton;
}
@end
