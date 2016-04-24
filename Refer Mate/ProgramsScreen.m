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
NSString* const categoryDidChange = @"categoryDidChange";

int currentIndex;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    topBox.layer.borderWidth = 3.0f;
    topBox.layer.borderColor = [UIColor colorWithRed:255/255.0 green:166/255.0 blue:38/255.0 alpha: 1.0].CGColor;
    categoriesArray = [[NSArray alloc] initWithObjects:@"services", @"shopping", @"banking", @"fitness", nil];
    categoryLabel.text = [categoriesArray objectAtIndex:currentIndex];
    ButtonImage = [UIImage imageNamed:@"rmlike-bw.png"];
    ButtonImageSelected = [UIImage imageNamed:@"rmlike-c.png"];
    
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];


    
    [self callFirebase];
    
    // Initialize the refresh control.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullRefresher:) forControlEvents:UIControlEventValueChanged];
    [myTableView addSubview:refreshControl];                  forControlEvents:UIControlEventValueChanged;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Actions for buttons
- (IBAction)connectToReferral:(id)sender {
    [self performSegueWithIdentifier:@"segueToProgramDetail" sender:nil];
}

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
    Firebase *favRef = [[Firebase alloc] initWithUrl:@"https://refer-mate.firebaseio.com"];
    NSString *programClickedTitle = [[NSString alloc] init];
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:myTableView];
    NSIndexPath *clickedButtonIndexPath = [myTableView indexPathForRowAtPoint:touchPoint];
    CustomCellClass *rowCell = [myTableView cellForRowAtIndexPath:clickedButtonIndexPath];
    programClickedTitle = rowCell.programNameString.text;

    //If row is selected, unselect and remove favorite
    NSLog(@"index path.row ==%ld",(long)clickedButtonIndexPath.row);
    if (rowCell.faveButton.isSelected)
    {
        [rowCell.faveButton setSelected:false];
        NSLog(@"%@ UNFAVORITED", programClickedTitle);
        NSLog(@"selected state %d", rowCell.faveButton.isSelected);
        
        //Remove from user_fovorites table
        NSDictionary *usersDictionary = @{
                                          programClickedTitle: @"false"
                                          };
        Firebase *usersRef = [favRef childByAppendingPath: @"user_favorites"];
        Firebase *setUser = [usersRef childByAppendingPath: ref.authData.uid];
        [setUser updateChildValues: usersDictionary];

//        Firebase *setProgram = [setUser childByAppendingPath: programClickedTitle];
//        [setProgram setValue: usersDictionary];
        
    }
    
    //If row is unselected, select and add favorite
    else if (!rowCell.faveButton.isSelected)
    {
        [rowCell.faveButton setSelected:true];
        NSLog(@"%@ FAVORITED", programClickedTitle);
        NSLog(@"selected state %d", rowCell.faveButton.isSelected);
        
        //Add to user_fovorites table
        NSDictionary *usersDictionary = @{
                                           programClickedTitle: @"true"
                                          };
        Firebase *usersRef = [favRef childByAppendingPath: @"user_favorites"];
        Firebase *setUser = [usersRef childByAppendingPath: ref.authData.uid];
        [setUser updateChildValues: usersDictionary];

//        Firebase *setProgram = [setUser childByAppendingPath: programClickedTitle];
//        [setProgram setValue: usersDictionary];
    }
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Custom methods
-(void)categoryPlus {
    if (currentIndex < [categoriesArray count]-1) {
        currentIndex++;
        categoryLabel.text = [categoriesArray objectAtIndex:currentIndex];
        [self callFirebase];
    }
}


-(void)categoryMinus {
    if (currentIndex > 0){
        currentIndex--;
        categoryLabel.text = [categoriesArray objectAtIndex:currentIndex];
        [self callFirebase];
    }
}


- (void)pullRefresher:(UIRefreshControl *)refreshControl {
    [myTableView reloadData];
    [refreshControl endRefreshing];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Tableview delegate methods

//Set number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (currentIndex)
    {
        case 0:
            return [servicesArray count];
            break;
        case 1:
            return [shoppingArray count];
            break;
        case 2:
            return [bankingArray count];
            break;
        case 3:
            return [fitnessArray count];
            break;
        default:
            return [servicesArray count];
            break;
    }
}


//Load cells with content from custom object
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellClass *programCell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    
//    [programCell.faveButton setImage:ButtonImage forState:UIControlStateNormal];
//    [programCell.faveButton setImage:ButtonImageSelected forState:UIControlStateSelected];
//    programCell.faveButton.tag = indexPath.row;
//    [programCell.faveButton addTarget:self action:@selector(changeFaveImage:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if(programCell != nil)
    {
        CustomProgramObject *currentProgram;
        
        switch (currentIndex)
        {
            case 0:
                if(servicesArray == 0){
                    
                }else{
                    currentProgram = [servicesArray objectAtIndex:indexPath.row];
                    programCell.programNameString.text = currentProgram.referralProgramName;
                    programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                    programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                    programCell.programDescriptionString = currentProgram.referralProgramDescription;
                    programCell.youGetAmount = currentProgram.referralProgramYouGet;
                    programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                }
                break;
            case 1:
                if(shoppingArray == 0){
                    
                }else{
                    currentProgram = [shoppingArray objectAtIndex:indexPath.row];
                    programCell.programNameString.text = currentProgram.referralProgramName;
                    programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                    programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                    programCell.programDescriptionString = currentProgram.referralProgramDescription;
                    programCell.youGetAmount = currentProgram.referralProgramYouGet;
                    programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                }
                break;
            case 2:
                if(bankingArray == 0){
                    
                }else{
                    currentProgram = [bankingArray objectAtIndex:indexPath.row];
                    programCell.programNameString.text = currentProgram.referralProgramName;
                    programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                    programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                    programCell.programDescriptionString = currentProgram.referralProgramDescription;
                    programCell.youGetAmount = currentProgram.referralProgramYouGet;
                    programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                }
                break;
            case 3:
                if(fitnessArray == 0){
                    
                }else{
                    currentProgram = [fitnessArray objectAtIndex:indexPath.row];
                    programCell.programNameString.text = currentProgram.referralProgramName;
                    programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                    programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                    programCell.programDescriptionString = currentProgram.referralProgramDescription;
                    programCell.youGetAmount = currentProgram.referralProgramYouGet;
                    programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                }
                break;
            default:
                if(servicesArray == 0){
                    
                }else{
                    currentProgram = [servicesArray objectAtIndex:indexPath.row];
                    programCell.programNameString.text = currentProgram.referralProgramName;
                    programCell.programFavesCount.text = currentProgram.referralProgramFaves;
                    programCell.programLogoURL.image = [UIImage imageWithData:currentProgram.referralProgramLogo];
                    programCell.programDescriptionString = currentProgram.referralProgramDescription;
                    programCell.youGetAmount = currentProgram.referralProgramYouGet;
                    programCell.theyGetAmount = currentProgram.referralProgramTheyGet;
                }
                break;
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


//Pass data to details screen from cell clicked
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"segueToProgramDetail"]){
    
        DetailScreen *detailController = segue.destinationViewController;
        if (detailController != nil){
            //UITableViewCell *clickedCell = (UITableViewCell*)sender;
            NSIndexPath *clickedIndex = [myTableView indexPathForSelectedRow];
            
            detailController.programLabelSegueString = [[resultArray objectAtIndex:clickedIndex.row]valueForKey:@"program_name"];
            
            detailController.detailTextViewSegueString = [[resultArray objectAtIndex:clickedIndex.row]valueForKey:@"description"];
            detailController.supporterLabelSegueString = [[resultArray objectAtIndex:clickedIndex.row]valueForKey:@"faved"];
            detailController.youGetSegueInt = [[resultArray objectAtIndex:clickedIndex.row]valueForKey:@"you_get"];
            detailController.theyGetSegueInt = [[resultArray objectAtIndex:clickedIndex.row]valueForKey:@"they_get"];
        }else if([[segue identifier] isEqualToString:@"segueToMenu"]){

        }
    }
}
@end
