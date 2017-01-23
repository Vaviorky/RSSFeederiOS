//
//  AddChannelViewController.m
//  RSSiOS
//
//  Created by Vav on 22/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import "AddChannelViewController.h"
#import "DBManager.h"
@interface AddChannelViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation AddChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Dodaj kanał";
    
    self.channelName.delegate = self;
    self.channelLink.delegate = self;
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFilename:@"database.sql"];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)addChannel:(id)sender {
    
    if(!(self.channelName && self.channelName.text.length>0 && self.channelLink.text && self.channelLink.text.length>0)) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Ostrzeżenie"
                                      message:@"Wszystkie pola muszą być wypełnione"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString *query = [NSString stringWithFormat:@"insert into rsschannel(name, link) values ('%@', '%@')", self.channelName.text, self.channelLink.text];
    
    //execute
    [self.dbManager executeQuery:query];
    
    //if the query was succesfully executed then pop the view controller
    if(self.dbManager.affectedRows!=0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        [self.delegate addingChannelFinished];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSLog(@"Could not execute the query");
        
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
