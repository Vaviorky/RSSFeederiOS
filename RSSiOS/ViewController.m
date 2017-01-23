//
//  ViewController.m
//  RSSiOS
//
//  Created by Vav on 07/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "ViewController.h"
#import "RSSItemsViewController.h"
#import "ToastView.h"
#import "MWFeedParser.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "RefreshAndAddToDatabase.h"

@interface ViewController ()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrChannelsInfo;

-(void) loadData;
-(BOOL) isOnline;
-(IBAction)refresh:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"RSS Feeder";
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.sql"];
    self.tblRssChannels.delegate = self;
    self.tblRssChannels.dataSource = self;
    
    //load data
   // [self removeAllData];
    [self loadData];
    
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
    
    NSInteger indexOfChannelName = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
    
    if(cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.arrChannelsInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfChannelName]];
    
    return cell;
}

-(IBAction)addNewChannel:(id)sender {
    [self performSegueWithIdentifier:@"addNewChannel" sender:self];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"mySegue"])
    {
        RSSItemsViewController *controller = (RSSItemsViewController *)segue.destinationViewController;
        controller.channelId = 1;
        //pass data
    }
    if ([[segue identifier] isEqualToString:@"addNewChannel"]) {
        AddChannelViewController *addChannelViewController = (AddChannelViewController *)segue.destinationViewController;
        addChannelViewController.delegate = self;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // [self performSegueWithIdentifier:@"mySegue" sender:self];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:.5];
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
