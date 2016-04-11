//
//  DetailScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "DetailScreen.h"

@implementation DetailScreen


//Actions for buttons
- (IBAction)addLink:(id)sender {
    [self performSegueWithIdentifier:@"segueToLinkSubmit" sender:nil];
}

- (IBAction)connectLink:(id)sender {
    [self performSegueWithIdentifier:@"segueToLinkReceive" sender:nil];
}

- (IBAction)goBack:(id)sender {
    [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
}

@end
