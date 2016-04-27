//
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/4/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "ProgramsScreen.h"
#import "CustomCellClass.h"
#import "CustomProgramObject.h"
#import "DetailScreen.h"
#import "MenuDrawer.h"



@interface ProgramsScreen ()

@end

@implementation ProgramsScreen
@synthesize barButtonItem;

Firebase *ref;
Firebase *ref2;
Firebase *searchRef;
NSString* const categoryDidChange = @"categoryDidChange";


int currentIndex;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    topBox.layer.borderWidth = 5.0f;
    topBox.layer.borderColor = [UIColor colorWithRed:255/255.0 green:166/255.0 blue:38/255.0 alpha: 1.0].CGColor;
    
    
    categoriesArray = [[NSArray alloc] initWithObjects:@"services", @"shopping", @"banking", @"fitness", nil];
    categoryLabel.text = [categoriesArray objectAtIndex:currentIndex];
    ButtonImage = [UIImage imageNamed:@"rmlike-bw.png"];
    ButtonImageSelected = [UIImage imageNamed:@"rmlike-c.png"];
    favoritesArray = [[NSMutableArray alloc] init];
    
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    favPref = [NSUserDefaults standardUserDefaults];
    
    
    [self callFirebase];
    
    // Initialize the refresh control.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullRefresher:) forControlEvents:UIControlEventValueChanged];
    [myTableView addSubview:refreshControl];                  forControlEvents:UIControlEventValueChanged;
}


-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *favPref = [NSUserDefaults standardUserDefaults];
    favoritesFromDefaults = [[favPref objectForKey:@"fave_array"] mutableCopy];
    searchBarBar.hidden = 1;
    [myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)categoryBack:(id)sender {
    [self categoryMinus];
}

- (IBAction)categoryForward:(id)sender {
    [self categoryPlus];
}

- (IBAction)unwindToPrograms:(UIStoryboardSegue *)unwindSegue{
}

- (IBAction)segueToMenu:(id)sender {
    [self performSegueWithIdentifier:@"segueToMenu" sender:nil];
}

- (IBAction)changeFaveImage:(id)sender{
    NSString *programClickedTitle = [[NSString alloc] init];
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:myTableView];
    NSIndexPath *clickedButtonIndexPath = [myTableView indexPathForRowAtPoint:touchPoint];
    CustomCellClass *rowCell = [myTableView cellForRowAtIndexPath:clickedButtonIndexPath];
    programClickedTitle = rowCell.programNameString.text;
    
    //If row is selected, unselect and remove favorite
    if (rowCell.faveButton.isSelected)
    {
        [rowCell.faveButton setSelected:false];
        
        [favoritesArray removeObject:programClickedTitle];
        [favPref setObject:favoritesArray forKey:@"fave_array"];
        [favPref synchronize];
        
    }
    
    //If row is unselected, select and add favorite
    else if (!rowCell.faveButton.isSelected)
    {
        [rowCell.faveButton setSelected:true];
        
        [favoritesArray addObject:programClickedTitle];
        [favPref setObject:favoritesArray forKey:@"fave_array"];
        [favPref synchronize];
    }
}

-(IBAction)searchGlassClick{
    searchBarBar.hidden = 0;
    [searchGlass setHidden:YES];
    
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Custom methods
-(void)categoryPlus {
    if (currentIndex < [categoriesArray count]-1) {
        currentIndex++;
        categoryLabel.text = [categoriesArray objectAtIndex:currentIndex];
        [self callFirebase];
    }else if([categoriesArray lastObject]){
        currentIndex = 0;
        categoryLabel.text = [categoriesArray objectAtIndex:currentIndex];
        [self callFirebase];
    }
}


-(void)categoryMinus {
    if (currentIndex > 0){
        currentIndex--;
        categoryLabel.text = [categoriesArray objectAtIndex:currentIndex];
        [self callFirebase];
    }else if ([categoriesArray firstObject]){
        currentIndex = (int)[categoriesArray count]-1;
        categoryLabel.text = [categoriesArray objectAtIndex:currentIndex];
        [self callFirebase];
    }
}


- (void)pullRefresher:(UIRefreshControl *)refreshControl {
    [myTableView reloadData];
    [refreshControl endRefreshing];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Searchbar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchGlass setHidden:YES];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBarBar.hidden = 1;
    [searchGlass setHidden:NO];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchTerm = searchBar.text;
    categoryLabel.text = @"search results";
    [self firebaseSearch];
    [searchBar resignFirstResponder];
    searchBarBar.hidden = 1;
    [searchGlass setHidden:NO];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Tableview delegate methods

//Set number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([categoryLabel.text  isEqual: @"search results"]){
        myCellCount = [searchArray count];
    }else if (currentIndex == 0){
        myCellCount = [servicesArray count];
    }else if (currentIndex == 1){
        myCellCount = [shoppingArray count];
    }else if (currentIndex == 2){
        myCellCount = [bankingArray count];
    }else if (currentIndex == 3){
        myCellCount = [fitnessArray count];
    }
    return myCellCount;
}


//Load cells with content from custom object
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellClass *programCell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    
    
    if(programCell != nil)
    {
        CustomProgramObject *currentProgram;
        
        if ([categoryLabel.text  isEqual: @"search results"]){
            if(searchArray == 0){
                
            }else{
                [programCell.faveButton setSelected:false];
                currentProgram = [searchArray objectAtIndex:indexPath.row];
                programCell.programNameString.text = currentProgram.referralProgramName;
                programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                programCell.programDescriptionString = currentProgram.referralProgramDescription;
                programCell.youGetAmount = currentProgram.referralProgramYouGet;
                programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                
                //Set fave button icon state
                if([favoritesFromDefaults containsObject:programCell.programNameString.text]){
                    [programCell.faveButton setSelected:true];
                }
                
                //Get the faves count from programs added
                ref2 = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/program_links"];
                [ref2 observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    NSArray *thisResult = [NSArray arrayWithObject:snapshot.value];
                    faveResultArray = [thisResult objectAtIndex:0];
                    long shareCount = [[faveResultArray valueForKey:currentProgram.referralProgramName] count];
                    programCell.programFavesCount.text = [NSString stringWithFormat:@"%lu", shareCount];
                }];
            }
        }else{
            switch (currentIndex)
            {
                case 0:
                    if(servicesArray == 0){
                        
                    }else{
                        [programCell.faveButton setSelected:false];
                        currentProgram = [servicesArray objectAtIndex:indexPath.row];
                        programCell.programNameString.text = currentProgram.referralProgramName;
                        programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                        programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                        programCell.programDescriptionString = currentProgram.referralProgramDescription;
                        programCell.youGetAmount = currentProgram.referralProgramYouGet;
                        programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                        
                        //Set fave button icon state
                        if([favoritesFromDefaults containsObject:programCell.programNameString.text]){
                            [programCell.faveButton setSelected:true];
                        }
                        
                        //Get the faves count from programs added
                        ref2 = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/program_links"];
                        [ref2 observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                            NSArray *thisResult = [NSArray arrayWithObject:snapshot.value];
                            faveResultArray = [thisResult objectAtIndex:0];
                            long shareCount = [[faveResultArray valueForKey:currentProgram.referralProgramName] count];
                            programCell.programFavesCount.text = [NSString stringWithFormat:@"%lu", shareCount];
                        }];
                    }
                    break;
                case 1:
                    if(shoppingArray == 0){
                        
                    }else{
                        [programCell.faveButton setSelected:false];
                        currentProgram = [shoppingArray objectAtIndex:indexPath.row];
                        programCell.programNameString.text = currentProgram.referralProgramName;
                        programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                        programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                        programCell.programDescriptionString = currentProgram.referralProgramDescription;
                        programCell.youGetAmount = currentProgram.referralProgramYouGet;
                        programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                        
                        //Set fave button icon state
                        if([favoritesFromDefaults containsObject:programCell.programNameString.text]){
                            [programCell.faveButton setSelected:true];
                        }
                        
                        //Get the faves count from programs added
                        ref2 = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/program_links"];
                        [ref2 observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                            NSArray *thisResult = [NSArray arrayWithObject:snapshot.value];
                            faveResultArray = [thisResult objectAtIndex:0];
                            long shareCount = [[faveResultArray valueForKey:currentProgram.referralProgramName] count];
                            programCell.programFavesCount.text = [NSString stringWithFormat:@"%lu", shareCount];
                        }];
                    }
                    break;
                case 2:
                    if(bankingArray == 0){
                        
                    }else{
                        [programCell.faveButton setSelected:false];
                        currentProgram = [bankingArray objectAtIndex:indexPath.row];
                        programCell.programNameString.text = currentProgram.referralProgramName;
                        programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                        programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                        programCell.programDescriptionString = currentProgram.referralProgramDescription;
                        programCell.youGetAmount = currentProgram.referralProgramYouGet;
                        programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                        
                        //Set fave button icon state
                        if([favoritesFromDefaults containsObject:programCell.programNameString.text]){
                            [programCell.faveButton setSelected:true];
                        }
                        
                        //Get the faves count from programs added
                        ref2 = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/program_links"];
                        [ref2 observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                            NSArray *thisResult = [NSArray arrayWithObject:snapshot.value];
                            faveResultArray = [thisResult objectAtIndex:0];
                            long shareCount = [[faveResultArray valueForKey:currentProgram.referralProgramName] count];
                            programCell.programFavesCount.text = [NSString stringWithFormat:@"%lu", shareCount];
                        }];
                    }
                    break;
                case 3:
                    if(fitnessArray == 0){
                        
                    }else{
                        [programCell.faveButton setSelected:false];
                        currentProgram = [fitnessArray objectAtIndex:indexPath.row];
                        programCell.programNameString.text = currentProgram.referralProgramName;
                        programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                        programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                        programCell.programDescriptionString = currentProgram.referralProgramDescription;
                        programCell.youGetAmount = currentProgram.referralProgramYouGet;
                        programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                        
                        //Set fave button icon state
                        if([favoritesFromDefaults containsObject:programCell.programNameString.text]){
                            [programCell.faveButton setSelected:true];
                        }
                        
                        //Get the faves count from programs added
                        ref2 = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/program_links"];
                        [ref2 observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                            NSArray *thisResult = [NSArray arrayWithObject:snapshot.value];
                            faveResultArray = [thisResult objectAtIndex:0];
                            long shareCount = [[faveResultArray valueForKey:currentProgram.referralProgramName] count];
                            programCell.programFavesCount.text = [NSString stringWithFormat:@"%lu", shareCount];
                        }];
                    }
                    break;
                default:
                    if(servicesArray == 0){
                        
                    }else{
                        [programCell.faveButton setSelected:false];
                        currentProgram = [servicesArray objectAtIndex:indexPath.row];
                        programCell.programNameString.text = currentProgram.referralProgramName;
                        programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                        programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                        programCell.programDescriptionString = currentProgram.referralProgramDescription;
                        programCell.youGetAmount = currentProgram.referralProgramYouGet;
                        programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                        
                        //Set fave button icon state
                        if([favoritesFromDefaults containsObject:programCell.programNameString.text]){
                            [programCell.faveButton setSelected:true];
                        }
                        
                        //Get the faves count from programs added
                        ref2 = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/program_links"];
                        [ref2 observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                            NSArray *thisResult = [NSArray arrayWithObject:snapshot.value];
                            faveResultArray = [thisResult objectAtIndex:0];
                            long shareCount = [[faveResultArray valueForKey:currentProgram.referralProgramName] count];
                            programCell.programFavesCount.text = [NSString stringWithFormat:@"%lu", shareCount];
                        }];
                    }
                    break;
            }
        }
    }else {
        NSLog(@"program cell is nil");
    }
    return programCell;
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Database handling

//Query Firebase database and handle JSON for tableview
-(void) callFirebase {
    if (currentIndex == 0) {
        servicesArray = [[NSMutableArray alloc] init];
        
        // Handle services category
        ref = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/programs/services"];
        
        // Query Firebase database
        [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSArray *firstResults = [NSArray arrayWithObject:snapshot.value];
            resultArray = [[firstResults objectAtIndex:0] allObjects];
            
            
            for (int i=0; i < [resultArray count]; i++){
                CustomProgramObject *program1 = [[CustomProgramObject alloc] init];
                program1.referralProgramName = [resultArray[i] valueForKey:@"program_name"];
                program1.referralProgramDescription = [resultArray[i] valueForKey:@"description"];
                program1.referralProgramFaves = [resultArray[i] valueForKey:@"faved"];
                program1.referralProgramYouGet = [resultArray[i] valueForKey:@"you_get"];
                program1.referralProgramTheyGet = [resultArray[i] valueForKey:@"they_get"];
                program1.referralProgramLogo = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[resultArray[i] valueForKey:@"logo_url"]]];
                
                [servicesArray addObject:program1];
            }
            [myTableView reloadData];
        }];
    }else if (currentIndex == 1){
        shoppingArray = [[NSMutableArray alloc] init];
        
        // Handle shopping category
        ref = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/programs/shopping"];
        
        // Query Firebase database
        [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSArray *firstResults = [NSArray arrayWithObject:snapshot.value];
            resultArray = [[firstResults objectAtIndex:0] allObjects];
            
            
            for (int i=0; i < [resultArray count]; i++){
                CustomProgramObject *program1 = [[CustomProgramObject alloc] init];
                program1.referralProgramName = [resultArray[i] valueForKey:@"program_name"];
                program1.referralProgramDescription = [resultArray[i] valueForKey:@"description"];
                program1.referralProgramFaves = [resultArray[i] valueForKey:@"faved"];
                program1.referralProgramYouGet = [resultArray[i] valueForKey:@"you_get"];
                program1.referralProgramTheyGet = [resultArray[i] valueForKey:@"they_get"];
                program1.referralProgramLogo = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[resultArray[i] valueForKey:@"logo_url"]]];
                
                [shoppingArray addObject:program1];
            }
            [myTableView reloadData];
        }];
    }else if (currentIndex == 2){
        bankingArray = [[NSMutableArray alloc] init];
        
        // Handle banking category
        ref = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/programs/banking"];
        
        // Query Firebase database
        [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSArray *firstResults = [NSArray arrayWithObject:snapshot.value];
            resultArray = [[firstResults objectAtIndex:0] allObjects];
            
            
            for (int i=0; i < [resultArray count]; i++){
                CustomProgramObject *program1 = [[CustomProgramObject alloc] init];
                program1.referralProgramName = [resultArray[i] valueForKey:@"program_name"];
                program1.referralProgramDescription = [resultArray[i] valueForKey:@"description"];
                program1.referralProgramFaves = [resultArray[i] valueForKey:@"faved"];
                program1.referralProgramYouGet = [resultArray[i] valueForKey:@"you_get"];
                program1.referralProgramTheyGet = [resultArray[i] valueForKey:@"they_get"];
                program1.referralProgramLogo = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[resultArray[i] valueForKey:@"logo_url"]]];
                
                [bankingArray addObject:program1];
            }
            [myTableView reloadData];
        }];
        
    }else if (currentIndex == 3){
        fitnessArray = [[NSMutableArray alloc] init];
        
        // Handle fitness category
        ref = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/programs/fitness"];
        
        // Query Firebase database
        [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSArray *firstResults = [NSArray arrayWithObject:snapshot.value];
            resultArray = [[firstResults objectAtIndex:0] allObjects];
            
            
            for (int i=0; i < [resultArray count]; i++){
                CustomProgramObject *program1 = [[CustomProgramObject alloc] init];
                program1.referralProgramName = [resultArray[i] valueForKey:@"program_name"];
                program1.referralProgramDescription = [resultArray[i] valueForKey:@"description"];
                program1.referralProgramFaves = [resultArray[i] valueForKey:@"faved"];
                program1.referralProgramYouGet = [resultArray[i] valueForKey:@"you_get"];
                program1.referralProgramTheyGet = [resultArray[i] valueForKey:@"they_get"];
                program1.referralProgramLogo = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[resultArray[i] valueForKey:@"logo_url"]]];
                
                [fitnessArray addObject:program1];
            }
            [myTableView reloadData];
        }];
    }
}





//Query Firebase database and handle JSON for tableview
-(void) firebaseSearch {
    searchArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<[categoriesArray count]; i++){
        NSString *searchURLString = [NSString stringWithFormat:@"https://refer-mate.firebaseio.com/programs/%@",categoriesArray[i]];
        searchRef = [[Firebase alloc] initWithUrl:searchURLString];
        
        [searchRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSArray *firstResults = [NSArray arrayWithObject:snapshot.value];
            resultArray = [[firstResults objectAtIndex:0] allObjects];
            
            for (int n; n<[resultArray count]; n++){
                
                if([[resultArray[n] valueForKey:@"program_name"] lowercaseString] == [searchTerm lowercaseString]){
                    
                    CustomProgramObject *program1 = [[CustomProgramObject alloc] init];
                    program1.referralProgramName = [resultArray[n] valueForKey:@"program_name"];
                    program1.referralProgramDescription = [resultArray[n] valueForKey:@"description"];
                    program1.referralProgramFaves = [resultArray[n] valueForKey:@"faved"];
                    program1.referralProgramYouGet = [resultArray[n] valueForKey:@"you_get"];
                    program1.referralProgramTheyGet = [resultArray[n] valueForKey:@"they_get"];
                    program1.referralProgramLogo = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[resultArray[n] valueForKey:@"logo_url"]]];
                    
                    [searchArray addObject:program1];
                    NSLog(@"search item found was %@", searchArray);
                }
            }
            [myTableView reloadData];
        }];
    }
}




//Pass data to details screen from cell clicked
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"segueToProgramDetail"]){
        
        DetailScreen *detailController = segue.destinationViewController;
        
        if (detailController != nil){
            NSIndexPath *clickedIndex = [myTableView indexPathForSelectedRow];
            CustomCellClass *cell = [myTableView cellForRowAtIndexPath:clickedIndex];
            
            detailController.programLabelSegueString = [[resultArray objectAtIndex:clickedIndex.row]valueForKey:@"program_name"];//cell.programNameString.text;//
            detailController.detailTextViewSegueString = [[resultArray objectAtIndex:clickedIndex.row]valueForKey:@"description"];
            detailController.supporterLabelSegueString = cell.programFavesCount.text;
            detailController.youGetSegueInt = [[resultArray objectAtIndex:clickedIndex.row]valueForKey:@"you_get"];
            detailController.theyGetSegueInt = [[resultArray objectAtIndex:clickedIndex.row]valueForKey:@"they_get"];
        }else if([[segue identifier] isEqualToString:@"segueToMenu"]){
            
        }
    }
}


@end
