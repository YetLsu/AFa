//
//  YYNoticCenterModel.h
//  通知中心
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYNoticCenterModel : NSObject
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy) NSString *titleNotic;
@property (nonatomic,copy) NSString *userSay;
@property (nonatomic,copy) NSString *contentNotic;
@property (nonatomic,copy) NSString *date;
@property (nonatomic) BOOL read;
@property (nonatomic,assign) NSInteger noticID;

+ (id)noticWithTiTle:(NSString *)titleNoctic withUserSay:(NSString *)userSay withContentNotic:(NSString *)contentNotic withDate:(NSString *)date withRead:(BOOL)read withNoticID:(NSInteger)noticID;


@end
