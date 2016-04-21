//
//  MenuDrawer.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/21/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "MenuDrawer.h"

@implementation MenuDrawer

-(void)viewDidLoad{
    [super viewDidLoad];
    menuView.layer.shadowColor = [UIColor grayColor].CGColor;
    menuView.layer.shadowOffset = CGSizeMake(5, 0);
    menuView.layer.shadowOpacity = .5;
    menuView.layer.shadowRadius = 5.0;
    
    clearView.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
//    [singleFingerTap release];
    
    
    
    
}

-(IBAction)logOutOfApp:(id)sender{
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    [ref unauth];
    [self performSegueWithIdentifier:@"segueToLogin" sender:nil];
}


//Dismissing the view on tap
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    CGRect tapZone = CGRectMake(285, 63, 300, 624);
    
    if (CGRectContainsPoint(tapZone, location)){
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    
//    // gets the coordinats of the touch with respect to the specified view.
//    CGPoint touchPoint = [touch locationInView:self];
//    
//    // test the coordinates however you wish,
//    ...
//}



@end
