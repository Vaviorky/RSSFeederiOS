//
//  ChannelItemDetailsViewController.m
//  RSSiOS
//
//  Created by Vav on 23/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "ChannelItemDetailsViewController.h"
#import "SiteViewController.h"
@interface ChannelItemDetailsViewController ()

@end

@implementation ChannelItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titlenews;
    self.dateAuthorLabel.text = self.date;
    self.descriptionLabel.text = self.desc;
    self.title = self.titlenews;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"site"])
    {
        NSLog(@"TUTAJ JESTEM");
        SiteViewController *controller = (SiteViewController *)segue.destinationViewController;
        controller.link = self.link;
    }
}

@end
