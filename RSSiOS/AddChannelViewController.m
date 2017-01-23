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
@property (nonatomic, assign) BOOL reachability;
- (BOOL) isStringUrl: (NSString*) candidate;
- (BOOL) checkReachabilityOfUrl: (NSString*) candidate;
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
    
    
    if(!(self.channelName && self.channelName.text.length>0 && self.channelLink.text && self.channelLink.text.length>0)) {
        
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (!([self isStringUrl:self.channelLink.text])) {
        alert=   [UIAlertController
                  alertControllerWithTitle:@"Ostrzeżenie"
                  message:@"Podany adres nie jest poprawnym adresem URL"
                  preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
        
    }
    
    BOOL reach;
    reach = [self checkReachabilityOfUrl:self.channelLink.text];
    [self setReachability:reach];
    
    if(![self reachability]) {
        alert=   [UIAlertController
                  alertControllerWithTitle:@"Ostrzeżenie"
                  message:@"Nie ma połączenia"
                  preferredStyle:UIAlertControllerStyleAlert];
        
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

- (BOOL) isStringUrl: (NSString*) candidate {
    NSURL *url = [NSURL URLWithString:candidate];
    
    if(url && url.scheme && url.host) {
        return YES;
    }
    else {
        return NO;
    }
}
- (BOOL)checkReachabilityOfUrl:(NSString *)candidate {
    NSURL *url = [NSURL URLWithString:candidate];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (data) {
        return YES;
    } else {
        return NO;
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
