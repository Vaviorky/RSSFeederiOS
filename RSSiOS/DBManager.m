//
//  DBManager.m
//  RSSiOS
//
//  Created by Vav on 21/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager()
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;
-(void) copyDatabaseIntoDocumentsDirectory;
-(void) runQuery:(const char*)query isQueryExecutable:(BOOL)queryExecutable;
@end;


@implementation DBManager
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename {
    self = [super init];
    if (self) {
        
        //set the documents directory path to the documentsDirectory property
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        //keep the database filename
        self.databaseFilename = dbFilename;
        
        //copy the database file into the documents directory if necessary
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

-(void) copyDatabaseIntoDocumentsDirectory {
    //check if the database file exists in the documents directory
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if(![[NSFileManager defaultManager]fileExistsAtPath:destinationPath]) {
        //the database file does not exist in the documents directory, so copy it from the main bundle now
        NSString *sourcePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager]copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        
        //check if any error occured during copying and display it
        if(error != nil) {
            NSLog(@"%@",[error localizedDescription]);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
    //create a sqlite object;
    sqlite3 *sqlite3Database;
    
    //set the database file path
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    //initialize the results array
    if(self.arrResults !=nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc]init];
    
    //initialize the column names array
    if(self.arrColumnNames!=nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc]init];
    
    //open the database
    NSLog(@"Before open database");
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    
    if(openDatabaseResult==SQLITE_OK) {
        //declare a sqlite_stmt object in which will be stored query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        NSLog(@"Open database successful");
        
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, nil);
        if(prepareStatementResult == SQLITE_OK) {
            //check if query is non-executable
            if (!queryExecutable) {
                //in this case data must be loaded from the database
                
                //declare an array to keep the data for each fetched row;
                NSMutableArray *arrDataRow;
                
                //loop through the results and add them to the results array row by row
                while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                    
                    //initialize the mutable array that will contain the data of a fetched row
                    arrDataRow = [[NSMutableArray alloc]init];
                    
                    //get the total number of columns
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    //go through all columns and fetch each column data
                    for (int i = 0; i<totalColumns; i++) {
                        //convert the column data to text (characters)
                        char *dbDataAsChars = (char*) sqlite3_column_text(compiledStatement, i);
                        
                        //if there are contents in the current column (field) then add them to the current row array.
                        if(dbDataAsChars!=NULL) {
                            //convert the characters to string
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        //keep the current column name
                        if(self.arrColumnNames.count != totalColumns) {
                        
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        
                        
                    }
                    //store each fetched data row in the results array, but first check if there is actually data
                    if (arrDataRow.count>0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                //this is the case of an executable query (insert, update, ...)
                
                //execute the query
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    //keep the affected rows
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    //keep the last inserted row id
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    //if could not execute the query show the error message on the debug
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            //in the database cannot be opened then show the error message on the debug
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        //release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    //close the database
    sqlite3_close(sqlite3Database);
}

- (NSArray *) loadDataFromDB:(NSString *)query {
    //run the query and indicate that is not executable
    //the query string is converted to a char* object
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    return (NSArray *)self.arrResults;
}

- (void)executeQuery:(NSString *)query {
    //run the query and indicate that is executable
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


@end
