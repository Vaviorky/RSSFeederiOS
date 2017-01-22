//
//  ToastView.h
//  RSSiOS
//
//  Created by Vav on 22/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToastView : UIView
@property (nonatomic, strong) NSString *text;

+(void) showToastInParentView: (UIView *)parentView withText:(NSString *)text withDuration:(float)duration;

@end
