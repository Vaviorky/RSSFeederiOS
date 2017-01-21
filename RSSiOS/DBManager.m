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
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult==SQLITE_OK) {}
        //declare a sqlite_stmt object in which will be stored query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
    
    
    BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        
}

@end
