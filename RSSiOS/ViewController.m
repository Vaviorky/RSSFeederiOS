//
//  ViewController.m
//  RSSiOS
//
//  Created by Vav on 07/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"RSS Feeder";
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    //liczba wierszy
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if(cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    cell.textLabel.text = @"Some text";
    NSString *cellText = [NSString stringWithFormat:@"Some text %ld", (long)indexPath.row];
    
    cell.textLabel.text = cellText;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
