//
//  YYOfficAndCustomCellFrame.m
//  OfficAndCustomColdModel
//
//  Created by Apple on 15/12/6.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYOfficColdCellFrame.h"
#import "YYOfficColdCellModel.h"

@implementation YYOfficColdCellFrame

- (void)setOfficAndCustomModel:(YYOfficColdCellModel *)officAndCustomModel{
    _officAndCustomModel = officAndCustomModel;

//    self.rowHeihgt = (211-30)/667.0*heightScreen +30 ;
    self.rowHeihgt = 12 + 29 + 15 + 5 *YY10HeightMargin + 105/667.0*heightScreen;
}

@end
