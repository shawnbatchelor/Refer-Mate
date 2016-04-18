//
//  SuggestProgramScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/17/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface SuggestProgramScreen : UIViewController
{
    IBOutlet UITextField *suggestedName;
    IBOutlet UITextView *suggestedDescription;
    IBOutlet UIButton *submitButton;
    IBOutlet UIButton *cancelButton;
}

@end
