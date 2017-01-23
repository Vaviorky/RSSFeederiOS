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
@class RSSItemsViewController;
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddChannelViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblRssChannels;
@property (strong, nonatomic) RSSItemsViewController *itemsViewController;

@end

