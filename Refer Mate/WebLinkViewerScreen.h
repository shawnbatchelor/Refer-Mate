//
//  WebLinkViewerScreen.h
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/22/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebLinkViewerScreen : UIViewController
{
    IBOutlet UIWebView *linkViewer;
    IBOutlet UIBarButtonItem *closeView;
    NSURL *linkURL;
}

@property(nonatomic, strong) NSString *helpURLString;
@property(nonatomic, strong) NSString *privacyURLString;
@property(nonatomic, strong) NSString *segueSenderID;

-(IBAction)onClick:(id)sender;

@end
