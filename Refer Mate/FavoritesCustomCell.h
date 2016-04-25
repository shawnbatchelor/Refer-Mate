//
//  FavoritesCustomCell.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/24/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesCustomCell : UITableViewCell
{
}

-(void)refreshFaveCell:(NSString*)faveString;
@property (nonatomic, strong) IBOutlet UILabel *favoriteLabel;


@end
