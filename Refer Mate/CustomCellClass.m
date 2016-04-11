//
//  CustomCellClass.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "CustomCellClass.h"

@implementation CustomCellClass

-(void) refreshCustomCell: (NSString*)programName supporterNumber:(NSString*)supporterNumber programLogo:(UIImage*)programPic{
    
    programLabel.text = programName;
    supporterLabel.text = supporterNumber;
    programLogo.image = programPic;
}

@end
