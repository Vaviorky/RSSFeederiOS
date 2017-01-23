//
//  RefreshAndAddToDatabase.h
//  RSSiOS
//
//  Created by Vav on 22/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"
@interface RefreshAndAddToDatabase : NSObject <MWFeedParserDelegate> {
    
    //parsing
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    
    //displaying
    NSArray *itemsToDisplay;
    NSDateFormatter *formatter;
}
@property (nonatomic, strong) NSArray *itemsToDisplay;
-(void) refreshDatabase;

@end
