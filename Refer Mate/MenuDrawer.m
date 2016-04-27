//
//  MenuDrawer.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/21/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "MenuDrawer.h"
#import "AppDelegate.h"


@implementation MenuDrawer

-(void)viewDidLoad{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userString = appDelegate.authenticatedUser;
    [self callFirebase];

    
    
    [super viewDidLoad];
    menuView.layer.shadowColor = [UIColor grayColor].CGColor;
    menuView.layer.shadowOffset = CGSizeMake(5, 0);
    menuView.layer.shadowOpacity = .5;
    menuView.layer.shadowRadius = 5.0;
    
    //clearView.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)logOutOfApp:(id)sender{
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    [ref unauth];
    [self performSegueWithIdentifier:@"segueToLogin" sender:nil];
}

-(IBAction)goToHelp:(id)sender{
        [self performSegueWithIdentifier:@"goToHelp" sender:nil];
}

-(IBAction)goToPrivacy:(id)sender{
        [self performSegueWithIdentifier:@"goToPrivacy" sender:nil];
}

-(IBAction)showSettings:(id)sender{
    [self performSegueWithIdentifier:@"segueToSettings" sender:nil];
}


//Dismissing the view on tap
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    CGRect tapZone = CGRectMake(285, 63, 300, 624);
    
    if (CGRectContainsPoint(tapZone, location)){
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

//Pass info to web viewer
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goToHelp"]){
        WebLinkViewerScreen *helpString = segue.destinationViewController;
        if (helpString != nil){
            helpString.segueSenderID = @"HelpSentMe";
            helpString.helpURLString = @"http://www.refermateapp.com";
        }else{
        }
    }else if ([[segue identifier] isEqualToString:@"goToPrivacy"]){
        WebLinkViewerScreen *privacyString = segue.destinationViewController;
        if (privacyString != nil){
            privacyString.segueSenderID = @"PrivacySentMe";
            privacyString.privacyURLString = @"http://www.refermateapp.com/privacy-policy/";
        }else{
        }
    }
}


//Call firebase to get pic
-(void) callFirebase {
    //Handle array of links
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/users"];
    
    // Query Firebase database
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *firstResults = [[NSArray arrayWithObject:snapshot.value] objectAtIndex:0];
        specifiedUserArray = [firstResults valueForKey:userString];
        
        
        //Get pic from Provider for web logins
        if ([userString rangeOfString:@"twitter"].location != NSNotFound ||
            [userString rangeOfString:@"facebook"].location != NSNotFound)
        {
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
    }];
}

@end
