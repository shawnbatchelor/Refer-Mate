//
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/4/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "ProgramsScreen.h"
#import "CustomCellClass.h"
#import "CustomProgramObject.h"


@interface ProgramsScreen ()

@end

@implementation ProgramsScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    topBox.layer.borderWidth = 3.0f;
    topBox.layer.borderColor = [UIColor colorWithRed:255/255.0 green:166/255.0 blue:38/255.0 alpha: 1.0].CGColor;
    
    // Get a reference to our posts
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://refer-mate.firebaseio.com/programs/services"];
    
    // Attach a block to read the data at our posts reference
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        servicesString = snapshot.value;
        servicesArray = [[NSMutableArray alloc] initWithObjects:servicesString, nil];
        NSLog(@"SERVICES ARRAY ::::: %@", servicesArray);

    }];
    
    

    // Do any additional setup after loading the view, typically from a nib.
    CustomProgramObject *program1 = [[CustomProgramObject alloc] init];
    program1.referralProgramName = @"Uber";
    program1.referralProgramFaves = @"1234";
    program1.referralProgramLogo = [UIImage imageNamed:@"uber.png"];
    
    CustomProgramObject *program2 = [[CustomProgramObject alloc] init];
    program2.referralProgramName = @"Xfinity";
    program2.referralProgramFaves = @"5678";
    program2.referralProgramLogo = [UIImage imageNamed:@"XFINITY_r.png"];

    
    CustomProgramObject *program3 = [[CustomProgramObject alloc] init];
    program3.referralProgramName = @"Regions";
    program3.referralProgramFaves = @"9876";
    
    CustomProgramObject *program4 = [[CustomProgramObject alloc] init];
    program4.referralProgramName = @"Chase";
    program4.referralProgramFaves = @"5432";
    
    //shoppingArray = [[NSMutableArray alloc] initWithObjects:program3, program4, nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Actions for buttons
- (IBAction)addToFavorites:(id)sender {

}

- (IBAction)connectToReferral:(id)sender {
    [self performSegueWithIdentifier:@"segueToProgramDetail" sender:nil];
}

- (IBAction)categoryBack:(id)sender {
    
}

- (IBAction)categoryForward:(id)sender {
    
}

//Table handling
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellClass *programCell = [tableView dequeueReusableCellWithIdentifier:@"referralProgramCell"];
    
    if(programCell != nil)
    {
        CustomProgramObject *currentProgram = [entertainmentArray objectAtIndex:indexPath.row];
        
        [programCell refreshCustomCell:currentProgram.referralProgramName supporterNumber:currentProgram.referralProgramFaves programLogo:currentProgram.referralProgramLogo];
        //programCell.textLabel.text = currentProgram.referralProgramName;
        //programCell.detailTextLabel.text = currentProgram.referralProgramSupporters;
    }

    return programCell;
}

/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
 */


@end
