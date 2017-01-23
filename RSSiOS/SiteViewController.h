//
//  SiteViewController.h
//  RSSiOS
//
//  Created by Vav on 23/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "ViewController.h"

@interface SiteViewController : ViewController
@property (strong, nonatomic) NSString *link;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
