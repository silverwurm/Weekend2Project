//
//  ViewController.m
//  Weekend2Project
//
//  Created by Mac on 4/19/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ViewController.h"

#define NEWS_URL @"http://news.google.com/news?ned=us&topic=h&output=rss"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray* NewsStories;
    int selectedRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create a listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadTable)name:@"TestNotification" object:nil];
    
    //add a tap gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
    
    //get the data
    
    WebServicesHandler* wsh = [[WebServicesHandler alloc] init];
    [wsh setDelegate:self];
    [wsh retrieveXMLDataAtURL:NEWS_URL];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //Ensure the table exists, if not, create it
    /*NSString* getRow = @"Select * from NewsFeeds";
    DatabaseManager* dbm = [[DatabaseManager alloc] init];
    [dbm SetDatabase:@"NewsFeedsProjectDatabase"];
    if([dbm RetrieveData:getRow] == nil)
    {
        //the table does not exist, create it
        [dbm ExecuteCommand:@"CREATE TABLE NewsFeeds (Title varchar(255), ImageURL varchar(255), Description varchar(255)"];
    }
    NSString* query = @"CREATE TABLE TestTable (PersonID int, LastName varchar(255), FirstName varchar(255), Address varchar(255), City varchar(255));";
    NSString* addrow = @"INSERT INTO TestTable VALUES (0, \"Ready\", \"Jason\", \"Somewhere\", \"A City\");";
    //NSString* getRow = @"Select * from TestTable;";
    [dbm ExecuteCommand:query];
    [dbm ExecuteCommand:addrow];
    NSArray* result = [dbm RetrieveData:getRow];
    NSLog(@"%@", result);
    NSString* removeTable = @"Drop Table TestTable;";
    [dbm ExecuteCommand:removeTable];
    result = [dbm RetrieveData:getRow];*/
    
}
-(void)ReloadTable
{
    [self.TableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [NewsStories count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //[cell setSubviews:[[NSArray alloc] init]];
    while([cell.subviews count] > 0)
          [cell.subviews[0] removeFromSuperview];
    UILabel* testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height/2.0)];
    testLabel.text = [NewsStories[indexPath.row] Title];
    UILabel* testLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height/2.0, cell.frame.size.width, cell.frame.size.height/2.0)];
    testLabel2.text = [NewsStories[indexPath.row] LinkURL];
    [cell addSubview:testLabel];
    [cell addSubview:testLabel2];
    return cell;
}
-(void)tapped:(UITapGestureRecognizer*)recog
{
    CGPoint tapLocation = [recog locationInView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:tapLocation];
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"ToWebView" sender:self];
}
/*-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = (int)indexPath.row;
    [self performSegueWithIdentifier:@"ToWebView" sender:self];
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSDictionary* dict = @{@"TARGET_URL":[NewsStories[selectedRow] LinkURL]};
    [segue.destinationViewController passSegueData:dict];
}

-(void)parsedData:(NSArray *)Results
{
    NewsStories = Results;
    [self ReloadTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
