//
//  UserProfileScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/17/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "UserProfileScreen.h"
#import "AppDelegate.h"


@implementation UserProfileScreen
@synthesize authenticatedUIDForProfileScreen;
//@synthesize userPicPic;

-(void)viewDidLoad{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userString = appDelegate.authenticatedUser;
    
    NSLog(@"USER ID PASSED %@", userString);

    [super viewDidLoad];
    [self callFirebase];
}
-(void) callFirebase {
    //Handle array of links
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/users"];
    
    // Query Firebase database
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *firstResults = [[NSArray arrayWithObject:snapshot.value] objectAtIndex:0];
        

        specifiedUserArray = [firstResults valueForKey:userString];
        userPicData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[specifiedUserArray valueForKey:@"profilePicURL"]]];

        NSLog(@"USER PIC URL ::: %@", [specifiedUserArray valueForKey:@"profilePicURL"]);
        //NSLog(@"ALL USERS ARRAY ::: %@", allUsersArray);

        usernameLabel.text = [specifiedUserArray valueForKey:@"displayName"];
        firstnameLabel.text = [specifiedUserArray valueForKey:@"firstname"];
        lastnameLabel.text = [specifiedUserArray valueForKey:@"lastname"];
        emailLabel.text = [specifiedUserArray valueForKey:@"email"];
        locationLabel.text = [specifiedUserArray valueForKey:@"zip_code"];
        username.text = usernameLabel.text;
        profilePic.image = [UIImage imageWithData:userPicData];
    }];
}


@end
