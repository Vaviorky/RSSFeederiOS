//
//  ChannelItem.h
//  RSSiOS
//
//  Created by Vav on 23/01/2017.
//  Copyright © 2017 Vav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelItem : NSObject
@property (nonatomic, assign) int ItemId;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSString *Author;
@property (nonatomic, strong) NSString *Link;
@property (nonatomic, strong) NSDate *Date;
@property (nonatomic, assign) int ChannelId;
@end
