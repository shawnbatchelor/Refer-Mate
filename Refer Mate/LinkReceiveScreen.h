//
//  LinkReceiveScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>


@interface LinkReceiveScreen : UIViewController

{
    IBOutlet UILabel *savedLabel;
    IBOutlet UILabel *sharedLabel;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UIImageView *userImage;
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *linkText;
    
    NSArray *programLinksArray;
    NSArray * allLinksArray;
    NSString *userAutoID;

}

@property(nonatomic, strong)NSString *fromProgramLabelSegueString;

@end
