//
//  WebLinkViewerScreen.m
//  Refer Mate
//
//  Created by Shawn Batchelor on 4/22/16.
//  Copyright © 2016 Shawn Batchelor. All rights reserved.
//

#import "WebLinkViewerScreen.h"

@implementation WebLinkViewerScreen
@synthesize helpURLString;
@synthesize privacyURLString;
@synthesize segueSenderID;
@synthesize linkReceiveURLString;

-(void)viewDidLoad{
        [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([self.segueSenderID  isEqual: @"HelpSentMe"]){
        
        linkURL = [[NSURL alloc] initWithString:self.helpURLString];
        if(linkURL != nil){
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:linkURL];
            if(request != nil){
                linkViewer.scalesPageToFit = 1;
                [linkViewer loadRequest:request];
            }
        }
    }else if ([self.segueSenderID  isEqual: @"PrivacySentMe"]){
        
        linkURL = [[NSURL alloc] initWithString:self.privacyURLString];
        if(linkURL != nil){
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:linkURL];
            if(request != nil){
                linkViewer.scalesPageToFit = 1;
                [linkViewer loadRequest:request];
            }
        }
    }else if ([self.segueSenderID  isEqual: @"LinkReceiveSentMe"]){
        
        linkURL = [[NSURL alloc] initWithString:self.linkReceiveURLString];
        if(linkURL != nil){
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:linkURL];
            if(request != nil){
                linkViewer.scalesPageToFit = 1;
                [linkViewer loadRequest:request];
            }
        }
    }
}

-(IBAction)onClick:(id)sender{
    UIBarButtonItem *webNavButton = (UIBarButtonItem*) sender;
    if(webNavButton != nil){
        //Back button
        if(webNavButton.tag == 0){
            if (linkViewer.canGoBack){
                [linkViewer goBack];
            }
            
            //Stop button
        }else if (webNavButton.tag == 1){
            if (linkViewer.isLoading){
                [linkViewer stopLoading];
            }
            
            //Reload button
        }else if (webNavButton.tag == 2){
                [linkViewer reload];
            
            //Forward button
        }else if (webNavButton.tag == 3){
            if (linkViewer.canGoForward){
                [linkViewer goForward];
            }
        }
    }
}

- (IBAction)closeWebView {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"goToPrograms" sender:nil];
}

@end
