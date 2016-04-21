//
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/4/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "FavoritesScreen.h"
#import "MenuDrawer.h"


@interface FavoritesScreen ()

@end

@implementation FavoritesScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"segueToMenu"]){
    }
}

@end
