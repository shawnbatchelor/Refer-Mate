//
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/4/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>



@interface ProgramsScreen : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

{
    IBOutlet UIButton *connectButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *forwardButton;
    IBOutlet UILabel *categoryLabel;
    IBOutlet UIView *topBox;
    NSArray *resultArray;
    IBOutlet UITableView *myTableView;
    IBOutlet UIButton *faveButton;
    IBOutlet UIButton *hamburger;
    IBOutlet UIButton *searchGlass;
    IBOutlet UISearchBar *searchBar;

    
    NSMutableArray *servicesArray;
    NSMutableArray *shoppingArray;
    NSMutableArray *bankingArray;
    NSMutableArray *fitnessArray;
    NSArray *categoriesArray;
    UIImage *ButtonImage;
    UIImage *ButtonImageSelected;
    
    
}

- (IBAction)changeFaveImage:(id)sender;
@property(nonatomic, strong) UIBarButtonItem *barButtonItem;


@end

