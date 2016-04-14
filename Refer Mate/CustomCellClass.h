//
//  CustomCellClass.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellClass : UITableViewCell

{
    IBOutlet UILabel *programLabel;
    IBOutlet UILabel *supporterLabel;
    IBOutlet UIImageView *programLogo;
    IBOutlet UIButton *faveButton;

}

-(void) refreshCustomCell: (NSString*)programName supporterNumber:(NSString*)supporterNumber programLogo:(UIImage*)programPic;
@end
