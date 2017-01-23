//
//  ViewController.h
//  RSSiOS
//
//  Created by Vav on 07/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "AddChannelViewController.h"
#import "MWFeedParser.h"
#import "NSString+HTML.h"
#import "ChannelItem.h"
@class RSSItemsViewController;
@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,AddChannelViewControllerDelegate, MWFeedParserDelegate> {
    //parsing
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    
    NSArray *itemsToDisplay;
    NSDateFormatter *formatter;
}

@property (weak, nonatomic) IBOutlet UITableView *tblRssChannels;
@property (strong, nonatomic) RSSItemsViewController *itemsViewController;
@property (nonatomic, strong) NSArray *itemsToDisplay;

@end

