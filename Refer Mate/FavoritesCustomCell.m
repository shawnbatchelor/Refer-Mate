//
//  FavoritesCustomCell.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/24/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "FavoritesCustomCell.h"

@implementation FavoritesCustomCell
@synthesize favoriteLabel;


-(void)refreshFaveCell:(NSString*)faveString{
    favoriteLabel.text = faveString;
}


@end
