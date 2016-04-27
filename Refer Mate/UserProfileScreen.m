//
//  UserProfileScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/17/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "UserProfileScreen.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "MenuDrawer.h"


@implementation UserProfileScreen
@synthesize authenticatedUIDForProfileScreen;
@synthesize userPicPic;

-(void)viewDidLoad{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userString = appDelegate.authenticatedUser;
    
//    NSLog(@"USER ID PASSED %@", userString);

    [super viewDidLoad];
    submitChangesButton.hidden = 1;
    uploadProfilePicButton.hidden = 1;
    cameraProfilePicButton.hidden = 1;
    localImageReference = @"";
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}


-(void)viewWillAppear:(BOOL)animated{
    getDefaultFavesArray = [[NSMutableArray alloc] init];
    userFavPref = [NSUserDefaults standardUserDefaults];
    getDefaultFavesArray = [[userFavPref objectForKey:@"user_pref_array"] mutableCopy];
    
    if (![self checkConnect])
    {
        [self noInternetAlert];
        [self loadFieldsWithoutInternet];
    } else {
        [self callFirebase];
    }
}


//Check Internet connection
- (BOOL)checkConnect{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


-(void)loadFieldsWithoutInternet{
    NSLog(@"%@", [getDefaultFavesArray[0] valueForKey:@"profilePicURL"]);
    usernameLabel.text = [getDefaultFavesArray[0] valueForKey:@"displayName"];
    firstnameLabel.text = [getDefaultFavesArray[0] valueForKey:@"firstname"];
    lastnameLabel.text = [getDefaultFavesArray[0] valueForKey:@"lastname"];
    emailLabel.text = [getDefaultFavesArray[0] valueForKey:@"email"];
    locationLabel.text = [getDefaultFavesArray[0] valueForKey:@"zip_code"];
    username.text = usernameLabel.text;
    oldUserEmail = [getDefaultFavesArray[0] valueForKey:@"email"];
    NSData *getData = [NSData dataWithContentsOfFile:[getDefaultFavesArray[0] valueForKey:@"profilePicURL"]];
    if(getData != nil)
    {
        profilePic.image = [UIImage imageWithData:getData];
    }
}



-(void) callFirebase {
    //Handle array of links
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/users"];
    
    // Query Firebase database
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *firstResults = [[NSArray arrayWithObject:snapshot.value] objectAtIndex:0];
        specifiedUserArray = [firstResults valueForKey:userString];
        
        usernameLabel.text = [specifiedUserArray valueForKey:@"displayName"];
        firstnameLabel.text = [specifiedUserArray valueForKey:@"firstname"];
        lastnameLabel.text = [specifiedUserArray valueForKey:@"lastname"];
        emailLabel.text = [specifiedUserArray valueForKey:@"email"];
        locationLabel.text = [specifiedUserArray valueForKey:@"zip_code"];
        username.text = usernameLabel.text;
        oldUserEmail = [specifiedUserArray valueForKey:@"email"];
        
        
        
        //Get pic from Provider for web logins
        if ([userString rangeOfString:@"twitter"].location != NSNotFound ||
            [userString rangeOfString:@"facebook"].location != NSNotFound)
        {
            editButton.hidden = 1;
            submitChangesButton.hidden = 1;
            userPicData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[specifiedUserArray valueForKey:@"providerPicURL"]]];
            profilePic.image = [UIImage imageWithData:userPicData];
        }else if ([specifiedUserArray valueForKey:@"profilePicURL"] == nil || [[specifiedUserArray valueForKey:@"profilePicURL"]  isEqual: @""]){
            //Load placeholder image
        }else{
            //Get file path from Firebase and use it to pull image from documents directory
            NSData *getData = [NSData dataWithContentsOfFile:[specifiedUserArray valueForKey:@"profilePicURL"]];
            if(getData != nil)
            {
                profilePic.image = [UIImage imageWithData:getData];
            }
        }
        
        //Log the data to user prefs
        NSDictionary *usersDictionary = @{
                                          @"firstname" : firstnameLabel.text,
                                          @"lastname" : lastnameLabel.text,
                                          @"displayName" : usernameLabel.text,
                                          @"email" : oldUserEmail,
                                          @"zip_code" : locationLabel.text,
                                          @"profilePicURL" : [specifiedUserArray valueForKey:@"profilePicURL"]
                                          };
        
        getDefaultFavesArray = [NSMutableArray arrayWithObject:usersDictionary];
        [userFavPref setObject:getDefaultFavesArray forKey:@"user_pref_array"];
        [userFavPref synchronize];
        
    }];
}

-(IBAction)editProfile:(id)sender {
    submitChangesButton.hidden = 0;
    
    usernameLabel.userInteractionEnabled = 1;
    usernameLabel.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:232/255.0 alpha: 0.10].CGColor;
    usernameLabel.placeholder = @"enter a new username";
    
    firstnameLabel.userInteractionEnabled = 1;
    firstnameLabel.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:232/255.0 alpha: 0.10].CGColor;
    firstnameLabel.placeholder = @"enter your firstname";
    
    lastnameLabel.userInteractionEnabled = 1;
    lastnameLabel.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:232/255.0 alpha: 0.10].CGColor;
    lastnameLabel.placeholder = @"enter your lastname";

    locationLabel.userInteractionEnabled = 1;
    locationLabel.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:232/255.0 alpha: 0.10].CGColor;
    locationLabel.placeholder = @"enter a new zip code";
    
    uploadProfilePicButton.hidden = 0;
    cameraProfilePicButton.hidden = 0;
}

-(IBAction)submitNewProfile:(id)sender{
    [self logUser];
    [self callFirebase];
}


-(IBAction)albumProfilePic{
    UIImagePickerController *pickPicker = [[UIImagePickerController alloc] init];
    pickPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickPicker.delegate = self;
    pickPicker.allowsEditing = true;
    [self presentViewController:pickPicker animated:true completion:NULL];
}

-(IBAction)cameraProfilePic{
    UIImagePickerController *pickPicker = [[UIImagePickerController alloc] init];
    pickPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickPicker.delegate = self;
    pickPicker.allowsEditing = true;
    [self presentViewController:pickPicker animated:true completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    localImageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    theData = [[NSData alloc] initWithContentsOfURL:localImageURL];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [searchPaths objectAtIndex:0];
    NSString *profilePicPath = [documentsPath stringByAppendingPathComponent:@"pickedImage.png"];
    
    //Write image to path for retrieval later
    [UIImagePNGRepresentation(pickedImage) writeToFile:profilePicPath atomically:YES];
    localImageReference = profilePicPath;
    
    profilePic.image = pickedImage;
    self.userPicPic = pickedImage;
    uploadProfilePicButton.hidden = 1;
    cameraProfilePicButton.hidden = 1;
    [picker dismissViewControllerAnimated:true completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Dismiss keyboard on tap
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//Check Internet connection
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

//No Internet Alert
-(void) noInternetAlert {
    //Not connected to the Intenet
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                   message:@"Looks like you have no Internet connection. Connect and try again"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//Tab through text fields
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextField = textField.tag +1;
    UIResponder* nextToRespond = [textField.superview viewWithTag:nextField];
    if (nextToRespond) {
        [nextToRespond becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

-(void)logUser{
    
    if([firstnameLabel.text length] == 0 || firstnameLabel.text == nil ||
       [lastnameLabel.text length] == 0 || lastnameLabel.text == nil ||
       [usernameLabel.text length] == 0 || usernameLabel.text == nil ||
       [locationLabel.text length] == 0 || locationLabel.text == nil)
    {
        //All fields are not completed
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stop!"
                                                                       message:@"You must complete all fields before continuing."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
        NSDictionary *usersDictionary = @{
                                          @"firstname" : firstnameLabel.text,
                                          @"lastname" : lastnameLabel.text,
                                          @"displayName" : usernameLabel.text,
                                          @"email" : oldUserEmail,
                                          @"zip_code" : locationLabel.text,
                                          @"profilePicURL" : localImageReference
                                          };
        Firebase *usersRef = [ref childByAppendingPath: @"users"];
        Firebase *setUser = [usersRef childByAppendingPath: userString];
        [setUser setValue: usersDictionary];
        
        getDefaultFavesArray = [NSMutableArray arrayWithObject:usersDictionary];
        [userFavPref setObject:getDefaultFavesArray forKey:@"user_pref_array"];
        [userFavPref synchronize];
        
        submitChangesButton.hidden = 1;
        [self disableUserEditing];
        username.text = usernameLabel.text;
    }
}

//Disable editing controls
-(void)disableUserEditing{
    usernameLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
    usernameLabel.userInteractionEnabled = 0;
    
    firstnameLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
    firstnameLabel.userInteractionEnabled = 0;
    
    lastnameLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
    lastnameLabel.userInteractionEnabled = 0;
    
    locationLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
    locationLabel.userInteractionEnabled = 0;
    
    uploadProfilePicButton.hidden = 1;
    cameraProfilePicButton.hidden = 1;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"segueToMenu"]){
    }
}




@end
