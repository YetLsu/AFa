//
//  YYEvaluateCell.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYEvaluateFrame;

@interface YYEvaluateCell : UITableViewCell

@property (nonatomic, strong)YYEvaluateFrame *evaluateFrame;


+ (instancetype)evaluateCellWithTableView:(UITableView *)tableView;
@end
