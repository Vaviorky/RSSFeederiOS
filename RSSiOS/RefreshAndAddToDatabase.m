//
//  RefreshAndAddToDatabase.m
//  RSSiOS
//
//  Created by Vav on 22/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "RefreshAndAddToDatabase.h"
#import "DBManager.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "RSSChannels.h"
#import "ChannelItem.h"
@interface RefreshAndAddToDatabase()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrChannelsInfo;
- (void) setupWork;
@end

@implementation RefreshAndAddToDatabase

@synthesize itemsToDisplay;

-(void)refreshDatabase {
    [self setupWork];
    
    NSString *query = @"select * from RSSChannel";
    if(self.arrChannelsInfo!=nil) {
        self.arrChannelsInfo=nil;
    }
    self.arrChannelsInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfChannelLink = [self.dbManager.arrColumnNames indexOfObject:@"Link"];
    NSInteger indexOfChannelId = [self.dbManager.arrColumnNames indexOfObject:@"ChannelId"];
    NSString *link;
    NSString *channelIdString;
    NSInteger channelId;
    NSURL *feedURL;
    for(int i =0;i<self.arrChannelsInfo.count;i++) {
        link = [NSString stringWithFormat:@"%@",[[self.arrChannelsInfo objectAtIndex:i] objectAtIndex:indexOfChannelLink]];
        channelIdString = [NSString stringWithFormat:@"%@",[[self.arrChannelsInfo objectAtIndex:i] objectAtIndex:indexOfChannelId]];
        channelId  = [channelIdString integerValue];
        
        feedURL = [NSURL URLWithString:link];
        feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        feedParser.delegate = self;
        feedParser.feedParseType = ParseTypeFull;
        feedParser.connectionType = ConnectionTypeAsynchronously;
        [feedParser parse];
        
        //ChannelItem *channel = ;
        //NSLog(@"%@, %@", channel.Title, channel.Description);
        
    }
    
}
-(void)setupWork {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.sql"];
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc]init];
    self.itemsToDisplay = [NSArray array];
}

-(void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSLog(@"Parsed Feed Info: “%@”", info.title);
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"Parsed Feed Item: “%@” \n\n", [item.summary stringByConvertingHTMLToPlainText]);
    ChannelItem *news = [[ChannelItem alloc]init];
    news.Title = item.title;
    NSString *desc = [item.summary stringByConvertingHTMLToPlainText];
    news.Description = desc;
    news.Author = item.author;
    news.Date = item.date;
    if (item) {
        [parsedItems addObject:news];
    }
}
-(void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
}
-(void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}
@end
