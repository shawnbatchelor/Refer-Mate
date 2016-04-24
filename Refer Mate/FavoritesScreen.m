//
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/4/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "FavoritesScreen.h"
#import "MenuDrawer.h"
#import "FavoritesCustomCell.h"
#import "AppDelegate.h"



@interface FavoritesScreen ()

@end

@implementation FavoritesScreen

- (void)viewDidLoad {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userString = appDelegate.authenticatedUser;
    [super viewDidLoad];
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self callFirebase];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"segueToMenu"]){
    }
}



-(void) callFirebase {
    favoritesFromFirebaseTable = [[NSMutableArray alloc] init];
    NSString * URLString = [NSString stringWithFormat:@"%@%@", @"https://refer-mate.firebaseio.com/user_favorites/", userString];
    
    // Query Firebase database
    Firebase *ref = [[Firebase alloc] initWithUrl: URLString];
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *firstResults = [NSArray arrayWithObject:snapshot.value];
//        resultArray = [[firstResults objectAtIndex:0] allObjects];
//        resultArray = [firstResults objectAtIndex:0];
        resultArray = [firstResults objectAtIndex:0];


        
        NSLog(@"%@", resultArray);
        NSLog(@" result array count is %lu", (unsigned long)[resultArray count]);

        
        
//        NSLog(@"%@", [resultArray ke]);
//        NSLog(@"%@", resultArray [0]);

        
//for (int i=0; i < [resultArray count]; i++){
//            CustomProgramObject *program1 = [[CustomProgramObject alloc] init];
//            program1.referralProgramName = [resultArray[i] valueForKey:@"program_name"];
//            program1.referralProgramDescription = [resultArray[i] valueForKey:@"description"];
//            program1.referralProgramFaves = [resultArray[i] valueForKey:@"faved"];
//            program1.referralProgramYouGet = [resultArray[i] valueForKey:@"you_get"];
//            program1.referralProgramTheyGet = [resultArray[i] valueForKey:@"they_get"];
//            program1.referralProgramLogo = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[resultArray[i] valueForKey:@"logo_url"]]];
//            
//            [servicesArray addObject:program1];
//        }
        [faveTableView reloadData];
    }];
}




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Tableview delegate methods

//Set number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultArray count];
}


//Load cells with content from custom object
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesCustomCell *favoriteCells = [tableView dequeueReusableCellWithIdentifier:@"faveCell"];
    
    if(favoriteCells != nil) {
        [favoriteCells refreshFaveCell:@"tempFave"];
    }else {
                NSLog(@"favoriteCell is nil");
            }

    return favoriteCells;
}


@end
