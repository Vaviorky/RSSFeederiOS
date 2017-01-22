//
//  DBManager.h
//  RSSiOS
//
//  Created by Vav on 21/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject


@property (nonatomic,strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

- (instancetype) initWithDatabaseFilename: (NSString *)dbFilename;
- (NSArray *)loadDataFromDB: (NSString *)query;
- (void)executeQuery:(NSString *)query;
@end
