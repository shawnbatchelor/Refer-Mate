//
//  DetailScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailScreen : UIViewController

{
    IBOutlet UIButton *addLink;
    IBOutlet UIButton *connectLink;
    IBOutlet UILabel *programLabel;
    IBOutlet UILabel *supporterLabel;
    IBOutlet UITextView *detailTextView;
    IBOutlet UIButton *backButton;
}

@property(nonatomic, strong)NSString *programLabelSegueString;
@property(nonatomic, strong)NSString *supporterLabelSegueString;
@property(nonatomic, strong)NSString *detailTextViewSegueString;
@property(nonatomic, strong)NSString *youGetSegueInt;
@property(nonatomic, strong)NSString *theyGetSegueInt;

@end
