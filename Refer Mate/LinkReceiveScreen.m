//
//  LinkReceiveScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "LinkReceiveScreen.h"

@implementation LinkReceiveScreen

@synthesize fromProgramLabelSegueString;


-(void)viewWillAppear:(BOOL)animated{
    [self callFirebase];
}


//Query Firebase database and handle JSON for tableview
-(void) callFirebase {
    //Handle array of links
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/program_links"];
        
        // Query Firebase database
        [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSArray *firstResults = [[NSArray arrayWithObject:snapshot.value] objectAtIndex:0];
            allLinksArray = [NSArray arrayWithObject: [firstResults valueForKey:self.fromProgramLabelSegueString]];
           
            
            programLinksArray = [[allLinksArray objectAtIndex:0] allObjects];
            int random = arc4random()%[programLinksArray count];
            usernameLabel.text = [programLinksArray[random] valueForKey:@"user_ID"];
            linkText.text = [programLinksArray[random] valueForKey:@"referral_link"];
        }];
}


@end
