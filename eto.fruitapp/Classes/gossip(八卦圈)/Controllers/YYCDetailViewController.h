//
//  YYCDetailViewController.h
//  圈子_V1
//
//  Created by Apple on 15/12/19.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYDynamicMessageModel;
@interface YYCDetailViewController : UIViewController
- (instancetype)initWithModel:(YYDynamicMessageModel *)model withGoToPerson:(NSString *)gotoPerson withWhere:(NSString *)where;
@end
