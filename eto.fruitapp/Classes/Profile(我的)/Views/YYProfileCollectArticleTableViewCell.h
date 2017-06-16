//
//  YYProfileCollectArticleTableViewCell.h
//  eto.fruitapp
//
//  Created by Apple on 16/2/22.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYCollectionArticleModel.h"

@interface YYProfileCollectArticleTableViewCell : UITableViewCell
@property (nonatomic,strong) YYCollectionArticleModel *model;

@property (nonatomic,assign) CGFloat rowheight;

+ (instancetype)YYProfileCollectArticleTableViewWithTableView:(UITableView *)tableview;

@end
