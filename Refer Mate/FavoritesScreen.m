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
    
    // Initialize the refresh control.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullRefresher:) forControlEvents:UIControlEventValueChanged];
    [faveTableView addSubview:refreshControl];                  forControlEvents:UIControlEventValueChanged;
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *favPref = [NSUserDefaults standardUserDefaults];
    favoritesFromDefaults = [[favPref objectForKey:@"fave_array"] mutableCopy];
    [faveTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"segueToMenu"]){
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Tableview delegate methods

//Set number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [favoritesFromDefaults count];
}


//Load cells with content from custom object
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesCustomCell *favoriteCells = [tableView dequeueReusableCellWithIdentifier:@"faveCell"];
    
    if(favoriteCells != nil) {
        [favoriteCells refreshFaveCell:[favoritesFromDefaults objectAtIndex:indexPath.row]];
    }else {
            }

    return favoriteCells;
}

//Pull to refresh
- (void)pullRefresher:(UIRefreshControl *)refreshControl {
    [faveTableView reloadData];
    [refreshControl endRefreshing];
}


//Swipe to delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUserDefaults *favPref = [NSUserDefaults standardUserDefaults];
        
        [favoritesFromDefaults removeObjectAtIndex:indexPath.row];
        [favPref setObject:favoritesFromDefaults forKey:@"fave_array"];
        [favPref synchronize];
        [faveTableView reloadData];
    }
}



@end
