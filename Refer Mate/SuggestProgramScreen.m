//
//  SuggestProgramScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/17/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "SuggestProgramScreen.h"
#import "Reachability.h"


@implementation SuggestProgramScreen

//Method for creating Firebase suggestion entry
-(void)logEntry{
    if([suggestedName.text length] == 0 || suggestedName.text == nil ||
       [suggestedDescription.text length] == 0 || suggestedDescription.text == nil)
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
        NSDictionary *suggestedDictionary = @{
                                              @"suggested_name" : suggestedName.text,
                                              @"suggested_description" : suggestedDescription.text,
                                              };
        Firebase *suggestRef = [ref childByAppendingPath: @"program_suggestions"];
        Firebase *setSuggestion = [suggestRef childByAutoId];
        [setSuggestion setValue: suggestedDictionary withCompletionBlock:^(NSError *error, Firebase *ref) {
            if (error) {
                //Couldn't log suggestion
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                               message:@"There was a problem saving your program suggestion. Please try again."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                //Submission successful
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Hooray!"
                                                                               message:@"Your suggestion was submitted. We'll review your suggestion and let you know if it fits."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [self performSegueWithIdentifier:@"unwindToProgramScreen" sender:nil];
                                                                      }];
                suggestedName.text = @"";
                suggestedDescription.text = @"";
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
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

//Action for submit button
- (IBAction)setSuggestion:(id)sender {
    if (![self connected])
    {
        [self noInternetAlert];
    } else {
        [self logEntry];
    }
}



@end
