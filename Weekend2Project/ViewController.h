//
//  ViewController.h
//  Weekend2Project
//
//  Created by Mac on 4/19/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServicesHandler.h"
#import "DatabaseManager.h"
#import "NewsStory.h"

@interface ViewController : UIViewController<WebServicesHandlerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TableView;


@end

