//
//  UserProfileScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/17/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>



@interface UserProfileScreen : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *profilePic;
    IBOutlet UILabel *username;
    IBOutlet UIButton *editButton;
    IBOutlet UITextField *firstnameLabel;
    IBOutlet UITextField *lastnameLabel;
    IBOutlet UITextField *usernameLabel;
    IBOutlet UITextField *emailLabel;
    IBOutlet UITextField *locationLabel;
    IBOutlet UIButton *submitChangesButton;
    IBOutlet UIButton *uploadProfilePicButton;
    IBOutlet UIButton *cameraProfilePicButton;

    
    NSArray *allUsersArray;
    NSArray *specifiedUserArray;
    NSString *userString;
    NSData * userPicData;
    NSString *oldUserEmail;
    NSString *localImageReference;
    NSURL *localImageURL;
    NSData *theData;
    NSUserDefaults *userFavPref;
    NSMutableArray *getDefaultFavesArray;
}

@property(nonatomic, strong)NSString *authenticatedUIDForProfileScreen;
@property (nonatomic, strong)UIImage *userPicPic;

@end
