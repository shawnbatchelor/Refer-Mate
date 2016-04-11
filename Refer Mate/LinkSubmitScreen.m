//
//  LinkSubmitScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "LinkSubmitScreen.h"

@implementation LinkSubmitScreen

//Actions for buttons
- (IBAction)submitLink:(id)sender {

}

- (IBAction)cancelLink:(id)sender {
    [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
}

- (IBAction)facebookShare:(id)sender {

}

- (IBAction)twitterShare:(id)sender {

}

- (IBAction)goBack:(id)sender {
    [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
}

@end
