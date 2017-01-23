//
//  RSSChannels.h
//  RSSiOS
//
//  Created by Vav on 07/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSChannels : NSObject

@property (nonatomic, assign) int Id;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Description;

@end
