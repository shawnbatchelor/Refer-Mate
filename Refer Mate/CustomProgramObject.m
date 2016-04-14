//
//  CustomProgramObject.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/10/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "CustomProgramObject.h"

@implementation CustomProgramObject

@synthesize referralProgramName;
@synthesize referralProgramFaves;
@synthesize referralProgramYouGet;
@synthesize referralProgramTheyGet;
@synthesize referralProgramDescription;
@synthesize referralProgramLogo;

/*
-(id)initWithJSONData:(NSDictionary*)data{
    self = [super init];
    if(self){
        //NSLog(@"initWithJSONData method called");
        self.referralProgramName = [data objectForKey:@"program_nams"];
        self.referralProgramFaves = [data objectForKey:@"faved"];
        self.referralProgramYouGet = [data objectForKey:@"you_get"];
        self.referralProgramTheyGet = [data objectForKey:@"they_get"];
        self.referralProgramDescription = [data objectForKey:@"description"];
        self.referralProgramLogo = [data objectForKey:@"logo_url"];

    }
    return self;
}
*/

@end
