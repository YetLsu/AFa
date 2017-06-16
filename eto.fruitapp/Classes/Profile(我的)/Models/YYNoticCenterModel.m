//
//  YYNoticCenterModel.m
//  通知中心
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYNoticCenterModel.h"

@implementation YYNoticCenterModel
+ (id)noticWithTiTle:(NSString *)titleNoctic withUserSay:(NSString *)userSay withContentNotic:(NSString *)contentNotic withDate:(NSString *)date withRead:(BOOL)read withNoticID:(NSInteger)noticID{
    return [[self alloc]initWithTiTle:(NSString *)titleNoctic withUserSay:(NSString *)userSay withContentNotic:(NSString *)contentNotic withDate:(NSString *)date withRead:(BOOL)read withNoticID:(NSInteger)noticID];
}

- (id)initWithTiTle:(NSString *)titleNoctic withUserSay:(NSString *)userSay withContentNotic:(NSString *)contentNotic withDate:(NSString *)date withRead:(BOOL)read withNoticID:(NSInteger)noticID{
    if (self = [super init]) {
        self.titleNotic = titleNoctic;
        self.userSay = userSay;
        self.contentNotic = contentNotic;
        self.date = date;
        
        self.read = read;
        self.noticID = noticID;
        
    }
    
    return self;
}


@end
