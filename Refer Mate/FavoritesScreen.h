//
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/4/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FavoritesScreen : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *favoritesFromDefaults;
    NSArray * resultArray;
    IBOutlet UITableView *faveTableView;
    NSString *userString;

}


@end

