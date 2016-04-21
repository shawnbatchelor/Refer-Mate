//
//  DisplayContentSegue.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/20/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "DisplayContentSegue.h"
#import "MenuViewController.h"
#import "MenuDrawViewController.h"

@implementation DisplayContentSegue

-(void)perform
{
    MenuDrawViewController* menuDrawerViewController = ((MenuViewController*)self.sourceViewController).menuDrawerViewController;
    menuDrawerViewController.content = self.destinationViewController;
}


@end
