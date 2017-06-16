//
//  YYDynamicMessageCell.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/20.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYDynamicMessageModel, YYDynamicMessageCell;

@protocol YYDynamicMessageCellDelegate <NSObject>

@optional
- (void)commentBtnToControllerClickWithModel:(YYDynamicMessageModel *)model;

- (void)attationBtnGuanZhuWith:(NSString *)attation bfuid:(NSString *)bfuid;

- (void)attationBtnQuGuanWith:(NSString *)attation bfuid:(NSString *)bfuid;


- (void)enlargePicture:(NSInteger)tag;

@end

@interface YYDynamicMessageCell : UITableViewCell

@property (nonatomic, strong) YYDynamicMessageModel *model;

@property (nonatomic, weak) id<YYDynamicMessageCellDelegate> delegate;

+ (instancetype)dynamicMessageCellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) CGFloat rowheight;
@end
