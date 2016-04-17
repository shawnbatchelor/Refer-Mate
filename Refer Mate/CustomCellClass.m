//
//  CustomCellClass.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "CustomCellClass.h"

@implementation CustomCellClass


@synthesize programNameString;
@synthesize programDescriptionString;
@synthesize programFavesCount;
@synthesize youGetAmount;
@synthesize theyGetAmount;
@synthesize programLogoURL;
@synthesize faveButton;

-(IBAction)setFave:(id)sender{
    NSLog(@"this method is in the custom cell class");
    if (faveButton.imageView.image == [UIImage imageNamed:@"rmlike-c.png"]){
        faveButton.imageView.image = [UIImage imageNamed:@"rmlike-bw.png"];
        
    }else if (faveButton.imageView.image == [UIImage imageNamed:@"rmlike-bw.png"]){
        faveButton.imageView.image = [UIImage imageNamed:@"rmlike-c.png"];
    }
}




@end
