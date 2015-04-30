//
//  WebViewController.h
//  Weekend2Project
//
//  Created by Mac on 4/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServicesHandler.h"

@interface WebViewController : UIViewController<SegueDataDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *WebView;
- (IBAction)GoBack:(id)sender;


@end
