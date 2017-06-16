//
//  YYOfficAndCustomCellFrame.h
//  OfficAndCustomColdModel
//
//  Created by Apple on 15/12/6.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YYOfficColdCellModel;
@interface YYOfficColdCellFrame : NSObject
@property (nonatomic,strong) YYOfficColdCellModel *officAndCustomModel;
@property (nonatomic,assign) CGFloat rowHeihgt;

@end
