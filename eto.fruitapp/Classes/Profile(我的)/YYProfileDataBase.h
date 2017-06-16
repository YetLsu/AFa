//
//  YYProfileDataBase.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/14.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYNoticCenterModel;

@interface YYProfileDataBase : NSObject
+ (instancetype)shareProfileDataBase;
//取出所有数据
- (NSMutableArray *)profile_notifications;
//存入一个数据
- (void)addprofile_notification:(YYNoticCenterModel *)model;
//删除一个数据
- (void)deleteprofile_notification:(YYNoticCenterModel *)model;
@end
