//
//  RefreshAndAddToDatabase.m
//  RSSiOS
//
//  Created by Vav on 22/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "RefreshAndAddToDatabase.h"
#import "DBManager.h"
@interface RefreshAndAddToDatabase()
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation RefreshAndAddToDatabase
-(void)refreshDatabase {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.sql"];
    
    
}
@end
