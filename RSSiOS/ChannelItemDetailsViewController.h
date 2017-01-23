//
//  ChannelItemDetailsViewController.h
//  RSSiOS
//
//  Created by Vav on 23/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "ViewController.h"

@interface ChannelItemDetailsViewController : ViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSString *titlenews;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *link;
@end
