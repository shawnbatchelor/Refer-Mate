//
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/4/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "Reachability.h"


@interface ProgramsScreen : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UISearchBarDelegate>

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
    IBOutlet UISearchBar *searchBarBar;

    NSMutableArray *searchArray;
    NSMutableArray *servicesArray;
    NSMutableArray *shoppingArray;
    NSMutableArray *bankingArray;
    NSMutableArray *fitnessArray;
    NSMutableArray *favoritesArray;
    NSMutableArray *favoritesFromDefaults;
    NSArray *categoriesArray;
    UIImage *ButtonImage;
    UIImage *ButtonImageSelected;
    NSUserDefaults *favPref;
    NSArray *faveResultArray;
    NSString *searchTerm;
    long myCellCount;
    
    Reachability *reachability;
    Reachability *initialCheck;

}

- (IBAction)changeFaveImage:(id)sender;
@property(nonatomic, strong) UIBarButtonItem *barButtonItem;
@property  BOOL internetActive;

@end

