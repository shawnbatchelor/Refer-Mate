//
//  LinkSubmitScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "LinkSubmitScreen.h"
#import "Reachability.h"
#import "MenuDrawer.h"


@implementation LinkSubmitScreen

@synthesize toProgramLabelSegueString;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

-(void)viewWillAppear:(BOOL)animated{
    userAutoID = [[NSString alloc] init];
}

//Actions for buttons
- (IBAction)setLink:(id)sender {
    if (![self connected])
    {
        [self noInternetAlert];
    } else {
        [self submitLink];
    }
}

- (IBAction)facebookShare:(id)sender {
    if([linkText.text length] == 0 || linkText.text == nil)
    {
        //All fields are not completed
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stop!"
                                                                       message:@"You must complete all fields before continuing."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:linkText.text];
        [FBSDKShareDialog showFromViewController:self
                                     withContent:content
                                        delegate:nil];
    }
}

- (IBAction)twitterShare:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *sendTweet = [SLComposeViewController
                                              composeViewControllerForServiceType:SLServiceTypeTwitter];
        if([linkText.text length] == 0 || linkText.text == nil)
        {
            //All fields are not completed
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stop!"
                                                                           message:@"You must complete all fields before continuing."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else{
            [sendTweet setInitialText:linkText.text];
            [self presentViewController:sendTweet animated:YES completion:nil];
        }
    }
}




//Method for creating Firebase suggestion entry
-(void)submitLink{
    if([linkText.text length] == 0 || linkText.text == nil)
    {
        //All fields are not completed
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stop!"
                                                                       message:@"You must complete all fields before continuing."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
        //Get current logged in user
        if (ref.authData) {
            // user authenticated
            userAutoID = ref.authData.uid;
            
            //Set dictionary to store link
            if ([ref.authData.provider  isEqual: @"password"]){
                linkDictionary = @{
                                   @"referral_link" : linkText.text,
                                   @"user_ID" : ref.authData.providerData[@"email"]
                                   };
            }else{
                linkDictionary = @{
                                   @"referral_link" : linkText.text,
                                   @"user_ID" : ref.authData.providerData[@"displayName"]
                                   };
            }
            
            
            Firebase *linkRef = [ref childByAppendingPath: @"program_links"];
            Firebase *linkSend = [linkRef childByAppendingPath:self.toProgramLabelSegueString];
            Firebase *linkFromUser = [linkSend childByAppendingPath:userAutoID];
            [linkFromUser updateChildValues: linkDictionary withCompletionBlock:^(NSError *error, Firebase *ref) {
                if (error) {
                    //Couldn't log link
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                                   message:@"There was a problem saving your link. Please try again."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    //Link submit successful
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Hooray!"
                                                                                   message:@"Your link was saved. It is now available for other mates to use, so you can get rewards."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                          }];
                    linkText.text = @"";
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        } else {
            NSLog (@"No user is signed in");
        }
        
    }
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

//Dismiss keyboard on tap
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"segueToMenu"]){
    }
}


@end
