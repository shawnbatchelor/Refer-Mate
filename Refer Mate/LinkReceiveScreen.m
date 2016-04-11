//
//  LinkReceiveScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "LinkReceiveScreen.h"

@implementation LinkReceiveScreen

//Actions for buttons
- (IBAction)goBack:(id)sender {
    [self performSegueWithIdentifier:@"segueToTabControl" sender:nil];
}

@end
