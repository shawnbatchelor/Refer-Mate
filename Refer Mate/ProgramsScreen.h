//
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/4/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgramsScreen : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *connectButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *forwardButton;
    IBOutlet UILabel *categoryLabel;
    NSArray *entertainmentArray;
    NSArray *bankingArray;
}

@end

