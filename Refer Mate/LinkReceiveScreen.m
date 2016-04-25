//
//  LinkReceiveScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "LinkReceiveScreen.h"
#import "MenuDrawer.h"
#import "AppDelegate.h"

@implementation LinkReceiveScreen

@synthesize fromProgramLabelSegueString;

-(void)viewDidLoad{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userString = appDelegate.authenticatedUser;
    [self getPic];
    
    
    [super viewDidLoad];
    
    pastyBoard = [UIPasteboard generalPasteboard];
    
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    copyButton.hidden = true;
    urlGOButton.hidden = true;
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
    
    NSURL *url = [NSURL URLWithString:linkText.text];
    if (url && url.scheme && url.host)
    {
        //the url is valid
        NSLog(@"the url is valid");
        receivedURLString = linkText.text;
        copyButton.hidden = true;
        urlGOButton.hidden = false;

    }else if (linkText.text != nil || ![linkText.text  isEqual: @""]){
        
        //The url is not valid
        NSLog(@"the url NOT valid");
        urlGOButton.hidden = true;
        copyButton.hidden = false;
    }
}




//Call firebase to get pic
-(void) getPic {
    //Handle array of links
    Firebase *picRef = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/users"];
    
    // Query Firebase database
    [picRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *firstResults = [[NSArray arrayWithObject:snapshot.value] objectAtIndex:0];
        specifiedUserArray = [firstResults valueForKey:userString];
        
        
        //Get pic from Provider for web logins
        if ([userString rangeOfString:@"twitter"].location != NSNotFound ||
            [userString rangeOfString:@"facebook"].location != NSNotFound)
        {
            userPicData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[specifiedUserArray valueForKey:@"providerPicURL"]]];
            userImage.image = [UIImage imageWithData:userPicData];
        }else if ([specifiedUserArray valueForKey:@"profilePicURL"] == nil || [[specifiedUserArray valueForKey:@"profilePicURL"]  isEqual: @""]){
            //Load placeholder image
        }else{
            //Get file path from Firebase and use it to pull image from documents directory
            NSData *getData = [NSData dataWithContentsOfFile:[specifiedUserArray valueForKey:@"profilePicURL"]];
            if(getData != nil)
            {
                userImage.image = [UIImage imageWithData:getData];
            }
        }
    }];
}


-(IBAction)copyText{
    pastyBoard.string = linkText.text;
}


-(IBAction)loadURL{
    [self performSegueWithIdentifier:@"goToWebViewer" sender:nil];
}


//Pass info to web viewer
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goToWebViewer"]){
        WebLinkViewerScreen *linkString = segue.destinationViewController;
        if (linkString != nil){
            linkString.segueSenderID = @"LinkReceiveSentMe";
            linkString.linkReceiveURLString = receivedURLString;
        }else{
        }
    }else if([[segue identifier] isEqualToString:@"segueToMenu"]){
    }
}





@end
