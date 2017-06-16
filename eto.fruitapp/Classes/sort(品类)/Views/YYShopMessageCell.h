//
//  YYShopMessageCell.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/10.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShopMessageFrame;

@protocol YYShopMessageDelegate<NSObject>

@optional
- (void)selectWayClick;

@end
@interface YYShopMessageCell : UITableViewCell

@property (nonatomic, weak) id<YYShopMessageDelegate> delegate;

@property (nonatomic, strong) YYShopMessageFrame *messageFrame;

+ (instancetype)shopMessageCellWithTableView:(UITableView *)tableView;
@end
