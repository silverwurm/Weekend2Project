//
//  DatabaseManager.h
//  Weekend2Project
//
//  Created by Mac on 4/19/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
//@property (nonatomic, strong) NSArray  *columnNames;
//@property (nonatomic, strong) NSMutableArray *arrColumnNames;
//@property (nonatomic) int affectedRows;
//@property (nonatomic) long long lastInsertedRowID;
//@property (nonatomic, strong) NSMutableArray *arrResults;

-(void)SetDatabase:(NSString*)DatabaseName;
-(NSArray*)RetrieveData:(NSString*)Query;
-(void)ExecuteCommand:(NSString*)Query;
@end
