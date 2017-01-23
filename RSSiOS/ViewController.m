//
//  ViewController.m
//  RSSiOS
//
//  Created by Vav on 07/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "ViewController.h"
#import "RSSItemsViewController.h"
#import "MWFeedParser.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"


@interface ViewController ()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrChannelsInfo;
@property (nonatomic, strong) NSArray *arrChannelItems;
@property (nonatomic, strong) NSArray *arrChannelNews;
@property (nonatomic, strong) NSArray *arrRssChannels;
@property (nonatomic, assign) int channelId;
-(int) getChannelId:(NSURL* )link;
-(void) loadData;
-(BOOL) isOnline;
-(IBAction)refresh:(id)sender;
-(BOOL) ifNewsItemExists:(long) date;
-(void) insertItem:(ChannelItem *)item :(long) date;
@end

@implementation ViewController
@synthesize itemsToDisplay;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"RSS Feeder";
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.sql"];
    self.tblRssChannels.delegate = self;
    self.tblRssChannels.dataSource = self;
    
    //load data
    //[self removeAllData];
    [self loadData];
}

- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
    int channelId = [self getChannelId:parser.url];
    self.channelId = channelId;
}

-(int)getChannelId:(NSURL *)link {
    NSString *query = [NSString stringWithFormat: @"select * from RssChannel where Link=\"%@\"",link];
    self.arrRssChannels = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfChannelId = [self.dbManager.arrColumnNames indexOfObject:@"ChannelId"];
    NSString *channelIdString = [NSString stringWithFormat:@"%@",[[self.arrRssChannels objectAtIndex:0] objectAtIndex:indexOfChannelId]];
    int channelId = [channelIdString intValue];
    return channelId;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    //NSLog(@"Parsed Feed Item: “%@” \n\n", [item.summary stringByConvertingHTMLToPlainText]);
    ChannelItem *newsItem = [[ChannelItem alloc] init];
    newsItem.Title = item.title;
    NSString *desc = [item.summary stringByConvertingHTMLToPlainText];
    newsItem.Description = desc;
    newsItem.Author = item.author;
    newsItem.Date = item.date;
    newsItem.Link = item.link;
    newsItem.ChannelId = self.channelId;
    if (item) [parsedItems addObject:newsItem];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    
    NSString *query = @"select * from RSSChannel";
    
    
    if(self.arrChannelNews != NULL) {
        self.arrChannelNews = NULL;
    }
    self.arrChannelNews = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    for(int i = 0; i<self.arrChannelNews.count;i++) {
        for(int j=0;j<parsedItems.count;j++) {
            ChannelItem *newsitem = [parsedItems objectAtIndex:j];
            long dateinlong = [newsitem.Date timeIntervalSince1970];
            if(![self ifNewsItemExists:dateinlong]) {
                //insert
                [self insertItem:newsitem :dateinlong];
                
            }
        }
    }
    
}



-(void)insertItem:(ChannelItem *)item :(long)date {
    
    item.Title = [item.Title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    item.Description = [item.Description stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    item.Link = [item.Link stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    item.Author = [item.Author stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *query = [NSString stringWithFormat:@"insert into ChannelItem(name, description, link, date, author, ChannelId) values ('%@', '%@', '%@', '%ld', '%@', '%d')", item.Title, item.Description, item.Link, date, item.Author, item.ChannelId];
    //execute
    NSLog(@"%@", query);
    [self.dbManager executeQuery:query];
}



-(BOOL)ifNewsItemExists:(long)date {
    
    NSString *query = [NSString stringWithFormat: @"select * from ChannelItem where date=\"%ld\"",date];
    
    NSArray *result = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if(result.count>0) {
        //NSLog(@"Yes yes");
        return YES;
    } else {
        //NSLog(@"NO NO NO");
        return NO;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    //liczba wierszy
    return self.arrChannelsInfo.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord"];
    cell.imageView.image = [UIImage imageNamed:@"rssicon.png"];
    
    NSInteger indexOfChannelName = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
    NSInteger indexOfChannelId = [self.dbManager.arrColumnNames indexOfObject:@"ChannelId"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idCellRecord"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.arrChannelsInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfChannelName]];
    NSString *channelIdString = [NSString stringWithFormat:@"%@",[[self.arrChannelsInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfChannelId]];
    NSInteger channelId = [channelIdString integerValue];
    cell.tag = channelId;
    return cell;
}

-(IBAction)addNewChannel:(id)sender {
    [self performSegueWithIdentifier:@"addNewChannel" sender:self];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"mySegue"])
    {
        UITableViewCell *cell = sender;
        RSSItemsViewController *controller = (RSSItemsViewController *)segue.destinationViewController;
        controller.channelId = cell.tag;
        controller.title = cell.textLabel.text;
    }
    if ([[segue identifier] isEqualToString:@"addNewChannel"]) {
        AddChannelViewController *addChannelViewController = (AddChannelViewController *)segue.destinationViewController;
        addChannelViewController.delegate = self;
    }
}

-(void)loadData {
    NSString *query = @"select * from RSSChannel";
    if(self.arrChannelsInfo != NULL) {
        self.arrChannelsInfo = NULL;
    }
    self.arrChannelsInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    [self.tblRssChannels reloadData];
}
- (void)addingChannelFinished {
    [self loadData];
}

- (BOOL)isOnline {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)refresh:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Wczytywanie"
                                  message:@"Nowe newsy są ładowane. Zaczekaj..."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    __weak ViewController *myself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        parsedItems = [[NSMutableArray alloc]init];
        myself.itemsToDisplay = [NSArray array];
        
        NSString *query = @"select * from RSSChannel";
        if(myself.arrChannelItems!=nil) {
            myself.arrChannelItems=nil;
        }
        myself.arrChannelItems = [[NSArray alloc] initWithArray:[myself.dbManager loadDataFromDB:query]];
        NSInteger indexOfChannelLink = [myself.dbManager.arrColumnNames indexOfObject:@"Link"];
        NSInteger indexOfChannelId = [myself.dbManager.arrColumnNames indexOfObject:@"ChannelId"];
        NSString *link;
        NSString *channelIdString;
        int channelId;
        NSURL *feedURL;
        for(int i =0;i<myself.arrChannelItems.count;i++) {
            link = [NSString stringWithFormat:@"%@",[[myself.arrChannelItems objectAtIndex:i] objectAtIndex:indexOfChannelLink]];
            channelIdString = [NSString stringWithFormat:@"%@",[[myself.arrChannelItems objectAtIndex:i] objectAtIndex:indexOfChannelId]];
            channelId  = [channelIdString intValue];
            feedURL = [NSURL URLWithString:link];
            feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
            feedParser.delegate = myself;
            feedParser.feedParseType = ParseTypeFull;
            feedParser.connectionType = ConnectionTypeAsynchronously;
            
            [feedParser performSelectorOnMainThread:@selector(parse) withObject:Nil waitUntilDone:YES];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        });
    });
}

-(void)removeAllData {
    NSString *query = [NSString stringWithFormat:@"delete from RSSChannel"];
    [self.dbManager executeQuery:query];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
