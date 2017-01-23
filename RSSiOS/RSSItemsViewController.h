//
//  RSSItemsViewController.h
//  RSSiOS
//
//  Created by Vav on 22/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger channelId;
@property (weak, nonatomic) IBOutlet UITableView *tblRssItems;
@end
