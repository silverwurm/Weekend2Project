//
//  WebViewController.m
//  Weekend2Project
//
//  Created by Mac on 4/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
{
    NSString* TARGET_URL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL* Tar_URL = [NSURL URLWithString:TARGET_URL];
    NSURLRequest* URL_REQUEST = [NSURLRequest requestWithURL:Tar_URL];
    [self.WebView loadRequest:URL_REQUEST];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)passSegueData:(NSDictionary *)Data
{
    TARGET_URL = [Data objectForKey:@"TARGET_URL"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)GoBack:(id)sender {
    [self performSegueWithIdentifier:@"BackToTable" sender:self];
}
@end
