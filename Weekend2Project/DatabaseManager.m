//
//  DatabaseManager.m
//  Weekend2Project
//
//  Created by Mac on 4/19/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "DatabaseManager.h"


@implementation DatabaseManager

-(void)SetDatabase:(NSString *)DatabaseName
{
    // Set the documents directory path to the documentsDirectory property.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentsDirectory = [paths objectAtIndex:0];
        
    // Keep the database filename.
    self.databaseFilename = DatabaseName;
        
    // Copy the database file into the documents directory if necessary.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath])
    {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        // Check if any error occurred during copying and display it.
        if (error != nil)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}
-(NSArray *)runQuery:(NSString *)Query isDataRequest:(BOOL)isDataRequest
{
    NSMutableArray* ColumnNames;
    NSMutableArray* Results;
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    bool OpenDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(OpenDatabaseResult == SQLITE_OK)
    {
        sqlite3_stmt* compiledStatement;
        bool StatementPreparationResult = sqlite3_prepare_v2(sqlite3Database, [Query UTF8String], -1, &compiledStatement, NULL);
        if(StatementPreparationResult == SQLITE_OK)
        {
            if(isDataRequest)
            {
                ColumnNames = [[NSMutableArray alloc] initWithCapacity:0];
                Results = [[NSMutableArray alloc] initWithCapacity:0];
                //statement compiled ok, load the colummn names
                int totalColumns = sqlite3_column_count(compiledStatement);
                for(int i = 0; i < totalColumns; i++)
                {
                    [ColumnNames setObject:[NSString stringWithUTF8String:sqlite3_column_name(compiledStatement, i)] atIndexedSubscript:i];
                }
                NSMutableDictionary* RowData = [[NSMutableDictionary alloc] init];
                while(sqlite3_step(compiledStatement)== SQLITE_ROW)
                {
                    for(int i = 0; i < totalColumns; i++)
                    {
                        char* char_data = (char*)sqlite3_column_text(compiledStatement, i);
                        if(char_data != NULL)
                        {
                            //set the data value in dictionary with column name
                            [RowData setValue:[NSString stringWithUTF8String:char_data] forKey:ColumnNames[i]];
                        }
                    }
                    //did it work?
                    if(RowData.count > 0)
                    {
                        //it did!
                        [Results addObject:RowData];
                    }
                }
            }
            else
            {
                if(sqlite3_step(compiledStatement) != SQLITE_DONE)
                {
                    //failed too apply the change
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        
        //now release compiled statement and close the database
        sqlite3_finalize(compiledStatement);
        sqlite3_close(sqlite3Database);
    }
    else
    {
        NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
    }
    return Results;
}
-(NSArray *)RetrieveData:(NSString *)Query
{
    return [self runQuery:Query isDataRequest:true];
}
-(void)ExecuteCommand:(NSString *)Query
{
    NSArray* spoo = [self runQuery:Query isDataRequest:false];
}
@end
