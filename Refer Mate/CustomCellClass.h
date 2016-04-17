//
//  CustomCellClass.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellClass : UITableViewCell

{
    //IBOutlet UIButton *faveButton;
}

@property (nonatomic, strong) IBOutlet UILabel *programNameString;
@property (nonatomic, strong) NSString *programDescriptionString;
@property (nonatomic, strong) IBOutlet UILabel *programFavesCount;
@property (nonatomic, strong) NSString *youGetAmount;
@property (nonatomic, strong) NSString *theyGetAmount;
@property (nonatomic, strong) IBOutlet UIImageView *programLogoURL;
@property (nonatomic, strong) IBOutlet UIButton *faveButton;

@end
