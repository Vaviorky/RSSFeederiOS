//
//  AddChannelViewController.h
//  RSSiOS
//
//  Created by Vav on 22/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToastView.h"

@protocol AddChannelViewControllerDelegate

-(void)addingChannelFinished;

@end

@interface AddChannelViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *channelName;
@property (weak, nonatomic) IBOutlet UITextField *channelLink;

-(IBAction)addChannel:(id)sender;

@property (nonatomic, strong) id<AddChannelViewControllerDelegate> delegate;

@end
