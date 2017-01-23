//
//  CustomRssCell.h
//  RSSiOS
//
//  Created by Vav on 23/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomRssCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customTitle;
@property (weak, nonatomic) IBOutlet UILabel *customDescription;
@property (weak, nonatomic) IBOutlet UILabel *customDate;
@property (weak, nonatomic) NSString *link;
@end
