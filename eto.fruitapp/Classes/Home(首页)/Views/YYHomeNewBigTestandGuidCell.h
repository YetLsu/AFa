//
//  YYHomeNewBigTestandGuidCell.h
//  eto.fruitapp
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYHomeNewBigTestModel;
@interface YYHomeNewBigTestandGuidCell : UITableViewCell
@property (nonatomic,strong) YYHomeNewBigTestModel *model;
@property (nonatomic,assign) CGFloat rowHeight;

+ (instancetype)HomeNewBigTestandGuidCellWithTableView:(UITableView *)table;

@end
