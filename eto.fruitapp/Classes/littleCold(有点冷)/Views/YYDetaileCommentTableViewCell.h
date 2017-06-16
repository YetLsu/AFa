//
//  YYDetaileCommentTableViewCell.h
//  YYDetaileCommentCellModel
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYDetaileCommentTableViewCell;

@protocol YYDetaileCommentTableViewCellDelegate <NSObject>

@optional
- (void)commentCellZanClick;

@end

#define YYCommentZan @"YYCommentZan"
#define YYCommentID @"YYCommentID"

@class YYDetailCommentModel,YYDetailCommentFrame;
@interface YYDetaileCommentTableViewCell : UITableViewCell


@property (nonatomic, weak) id<YYDetaileCommentTableViewCellDelegate> delegate;
@property (nonatomic,strong) YYDetailCommentFrame *cellFrame;
@property (nonatomic) CGSize cellSize;
@property (nonatomic,strong) UILabel *toLabel;


+ (id)DetailCommentTableViewCell:(UITableView *)tableView WithPort:(NSInteger)port;


@end
