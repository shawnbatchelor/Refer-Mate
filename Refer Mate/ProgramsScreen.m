//
//  FirstViewController.m
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
    // Do any additional setup after loading the view, typically from a nib.
    
    CustomProgramObject *program1 = [[CustomProgramObject alloc] init];
    program1.referralProgramName = @"Uber";
    program1.referralProgramSupporters = @"1234";
    program1.referralProgramCategory = @"Entertainment";
    program1.referralProgramLogo = [UIImage imageNamed:@"uber.png"];
    
    CustomProgramObject *program2 = [[CustomProgramObject alloc] init];
    program2.referralProgramName = @"Xfinity";
    program2.referralProgramSupporters = @"5678";
    program2.referralProgramCategory = @"Entertainment";
    program2.referralProgramLogo = [UIImage imageNamed:@"XFINITY_r.png"];

    
    CustomProgramObject *program3 = [[CustomProgramObject alloc] init];
    program3.referralProgramName = @"Regions";
    program3.referralProgramSupporters = @"9876";
    program3.referralProgramCategory = @"Banking";
    
    CustomProgramObject *program4 = [[CustomProgramObject alloc] init];
    program4.referralProgramName = @"Chase";
    program4.referralProgramSupporters = @"5432";
    program4.referralProgramCategory = @"Banking";
    
    
    entertainmentArray = [[NSArray alloc] initWithObjects:program1, program2, nil];
    bankingArray = [[NSArray alloc] initWithObjects:program3, program4, nil];
    
    
    
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
        
        [programCell refreshCustomCell:currentProgram.referralProgramName supporterNumber:currentProgram.referralProgramSupporters programLogo:currentProgram.referralProgramLogo];
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
