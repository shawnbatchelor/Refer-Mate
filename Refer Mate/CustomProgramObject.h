//
//  CustomProgramObject.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface CustomProgramObject : NSObject
{
    
}



@property (nonatomic, strong)NSString *referralProgramName;
@property (nonatomic, strong)NSString *referralProgramFaves;
@property (nonatomic, strong)NSString *referralProgramCategory;
@property (nonatomic, strong)NSString *referralProgramYouGet;
@property (nonatomic, strong)NSString *referralProgramTheyGet;
@property (nonatomic, strong)NSString *referralProgramDescription;
@property (nonatomic, strong)NSData *referralProgramLogo;

@end
