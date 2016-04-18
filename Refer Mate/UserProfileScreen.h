//
//  UserProfileScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/17/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>


@interface UserProfileScreen : UIViewController
{
    IBOutlet UIImageView *profilePic;
    IBOutlet UILabel *username;
    IBOutlet UIButton *editButton;
    IBOutlet UILabel *firstnameLabel;
    IBOutlet UILabel *lastnameLabel;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *emailLabel;
    IBOutlet UILabel *locationLabel;
    
    NSArray *allUsersArray;
    NSArray *specifiedUserArray;
    NSString *userString;
}

@property(nonatomic, strong)NSString *authenticatedUIDForProfileScreen;

@end
