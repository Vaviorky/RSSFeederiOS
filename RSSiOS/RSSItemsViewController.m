//
//  RSSItemsViewController.m
//  RSSiOS
//
//  Created by Vav on 22/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "RSSItemsViewController.h"
#import "DBManager.h"
#import "CustomRssCell.h"
#import "ChannelItemDetailsViewController.h"
@interface RSSItemsViewController ()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrChannelItems;
-(void)loadItems;
@end

@implementation RSSItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.sql"];
    self.tblRssItems.delegate = self;
    self.tblRssItems.dataSource = self;
    
    // Do any additional setup after loading the view.
    [self loadItems];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrChannelItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomRssCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (customCell==nil) {
        customCell = [[CustomRssCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSInteger indexOfItemName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
    NSInteger indexOfItemDescription = [self.dbManager.arrColumnNames indexOfObject:@"description"];
    NSInteger indexOfItemDate = [self.dbManager.arrColumnNames indexOfObject:@"date"];
    NSInteger indexOfItemAuthor = [self.dbManager.arrColumnNames indexOfObject:@"author"];
    NSInteger indexOfItemLink = [self.dbManager.arrColumnNames indexOfObject:@"link"];
    
    customCell.customTitle.text = [NSString stringWithFormat:@"%@",[[self.arrChannelItems objectAtIndex:indexPath.row] objectAtIndex:indexOfItemName]];
    customCell.customDescription.text = [NSString stringWithFormat:@"%@",[[self.arrChannelItems objectAtIndex:indexPath.row] objectAtIndex:indexOfItemDescription]];
    
    NSString *author = [[self.arrChannelItems objectAtIndex:indexPath.row] objectAtIndex:indexOfItemAuthor];
    NSString *date = [[self.arrChannelItems objectAtIndex:indexPath.row] objectAtIndex:indexOfItemDate];
    customCell.link = [[self.arrChannelItems objectAtIndex:indexPath.row] objectAtIndex:indexOfItemLink];
    
    long datelong = [date longLongValue];
    NSDate *dateobject = [NSDate dateWithTimeIntervalSince1970:datelong];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *datetoLabel = [formatter stringFromDate:dateobject];
    
    if ([author isEqual:@"(null)"]) {
        customCell.customDate.text = [NSString stringWithFormat:@"%@",datetoLabel];
    } else {
        NSString *leftbracket = [author componentsSeparatedByString:@"("][1];
        NSString *rightbracket = [leftbracket componentsSeparatedByString:@")"][0];
        customCell.customDate.text = [NSString stringWithFormat:@"%@, %@",datetoLabel, rightbracket];
    }
    
    
    return customCell;
}
-(void)loadItems {
    NSString *query = [NSString stringWithFormat: @"select * from ChannelItem where channelid=%ld order by date desc", (long)self.channelId];
    
    if(self.arrChannelItems != NULL) {
        self.arrChannelItems = NULL;
    }
    self.arrChannelItems = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"%lu", (unsigned long)self.arrChannelItems.count);
    
    
    [self.tblRssItems reloadData];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"newsDetails"])
    {
        CustomRssCell *cell = sender;
        ChannelItemDetailsViewController *controller = (ChannelItemDetailsViewController *)segue.destinationViewController;
        controller.titlenews = cell.customTitle.text;
        controller.date= cell.customDate.text;
        controller.desc= cell.customDescription.text;
        controller.link = cell.link;
        NSLog(@"%@", cell.link);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
