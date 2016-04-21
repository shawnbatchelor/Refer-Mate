//
//  DetailScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "DetailScreen.h"
#import "LinkSubmitScreen.h"
#import "LinkReceiveScreen.h"
#import "MenuDrawer.h"


@implementation DetailScreen


//Actions for buttons
- (IBAction)addLink:(id)sender {
    
    [self performSegueWithIdentifier:@"segueToLinkSubmit" sender:nil];
}

- (IBAction)connectLink:(id)sender {
    [self performSegueWithIdentifier:@"segueToLinkReceive" sender:nil];
}

- (IBAction)unwindToDetails:(UIStoryboardSegue *)unwindSegue
{
}

-(void)viewWillAppear:(BOOL)animated{
    programLabel.text = self.programLabelSegueString;
    supporterLabel.text = self.supporterLabelSegueString;
    detailTextView.text = self.detailTextViewSegueString;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}


//Pass data to link submit screen from cell clicked
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"segueToLinkSubmit"]){
        LinkSubmitScreen *linkController = segue.destinationViewController;
        if (linkController != nil){
            linkController.toProgramLabelSegueString = self.programLabelSegueString;
        }
    }else if ([[segue identifier] isEqualToString:@"segueToLinkReceive"]){
        LinkReceiveScreen *getController = segue.destinationViewController;
        if (getController != nil){
            getController.fromProgramLabelSegueString = self.programLabelSegueString;
        }
    }else if([[segue identifier] isEqualToString:@"segueToMenu"]){
        
    }
}



@end
