//
//  YYTableViewCell.m
//  Model12_5
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYLittleColdHotCell.h"

#import "YYLittleColdHotCellmodel.h"

#define YY13Font [UIFont systemFontOfSize:13]

#define ZAN [UIImage imageNamed:@"littleCold_zan_normal"]
#define PINGLUN [UIImage imageNamed:@"littleCold_comment_h"]
#define YYLightGray [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1]
#define YYTimeLabel [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1]
@interface YYLittleColdHotCell ()

@property (nonatomic,weak) UIImageView *leftImageView;
@property (nonatomic,weak) UILabel *leftLabel;//小标题
@property (nonatomic,weak) UILabel *titleLabelView;
@property (nonatomic,weak) UILabel *downContentLabel;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UIImageView *zanImageView;
@property (nonatomic,weak) UILabel *numberZanLabelView;
@property (nonatomic,weak) UIImageView *commentImageView;
@property (nonatomic,weak) UILabel *numberCommentLabelView;

@end

@implementation YYLittleColdHotCell


//自定义新建的cell

+ (instancetype)littleColdHotCellWithTableView:(UITableView *)tableView{
    static NSString *indenti = @"DownCell";
    YYLittleColdHotCell *cell = [tableView dequeueReusableCellWithIdentifier:indenti];
    if (!cell) {
        cell = [[YYLittleColdHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenti];
    }
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //左边的图片
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, 10, 90, 90)];
        [self.contentView addSubview:leftImageView];

        self.leftImageView = leftImageView;
        self.leftImageView.contentMode = UIViewContentModeScaleToFill;
        
        //标题左边的label
        CGFloat leftLabelX = (16+8)/375.0*widthScreen + 90;
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelX, 15, 30.5, 13)];
        [self.contentView addSubview:leftLabel];
        self.leftLabel = leftLabel;
        self.leftLabel.backgroundColor = [UIColor colorWithRed:178/255.0 green:151/255.0 blue:40/255.0 alpha:1];
       
        self.leftLabel.textColor = [UIColor whiteColor];
        self.leftLabel.font = [UIFont systemFontOfSize:13];
        self.leftLabel.textAlignment = 1;//居中
        
        
        //标题
        CGFloat titleX = (16 + 8 + 2)/375.0 *widthScreen;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleX + 90+30.5, 14, widthScreen - 30.5 - 90 - titleX, 15)];
        [self.contentView addSubview:title];
        self.titleLabelView = title;
        self.titleLabelView.textAlignment = 0;
        self.titleLabelView.font = [UIFont systemFontOfSize:14];
        
        //内容
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelX, 30, widthScreen - 30.5 - 90 - titleX, 38)];
        [self.contentView addSubview:content];
        self.downContentLabel = content;
        self.downContentLabel.numberOfLines = 0;
        self.downContentLabel.font = [UIFont systemFontOfSize:14];
        self.downContentLabel.textColor = YYLightGray;
        
        //时间
        UILabel *timelb = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelX, 85, 100, 12)];
        [self.contentView addSubview:timelb];
        self.timeLabel = timelb;
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textAlignment = 0;
        self.timeLabel.textColor = YYTimeLabel;
        
        //赞图
        UIImageView *zanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(widthScreen - 113, 85, 15, 15)];
        [self.contentView addSubview:zanImageView];
        self.zanImageView = zanImageView;
        self.zanImageView.image = ZAN;
        
        //赞数
        UILabel *zanNumber = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen - 94, 89, 30, 12)];
        [self.contentView addSubview:zanNumber];
        self.numberZanLabelView = zanNumber;
        self.numberZanLabelView.font = [UIFont systemFontOfSize:14];
        self.numberZanLabelView.textAlignment = 0;
        self.numberZanLabelView.textColor = YYTimeLabel;
        //self.zanImageView.backgroundColor = [UIColor blackColor];
        
        //评论图142 + 84
        UIImageView *comment = [[UIImageView alloc] initWithFrame:CGRectMake(widthScreen - 63, 85, 15, 15)];
        [self.contentView addSubview:comment];
        self.commentImageView = comment;
        self.commentImageView.image = PINGLUN;
        
        //评论数
        UILabel *commentNumber = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen - 44, 89, 30, 12)];
        [self.contentView addSubview:commentNumber];
        self.numberCommentLabelView = commentNumber;
        self.numberCommentLabelView.font = [UIFont systemFontOfSize:14];
        self.numberCommentLabelView.textAlignment = 0;
        self.numberCommentLabelView.textColor = YYTimeLabel;
        
    }
    return self;
}

//设置frame

- (void)setHotCellModel:(YYLittleColdHotCellmodel *)hotCellModel{
    _hotCellModel = hotCellModel;
    
    self.leftImageView.image = _hotCellModel.leftImage;
    self.leftLabel.text = _hotCellModel.leftTitle;
    self.titleLabelView.text = _hotCellModel.title;
    self.downContentLabel.text = _hotCellModel.content;
    self.zanImageView.image = ZAN;
    self.numberZanLabelView.text = [NSString stringWithFormat:@"%ld",(long)_hotCellModel.numberOfZan];
    self.commentImageView.image = PINGLUN;
    self.numberCommentLabelView.text = [NSString stringWithFormat:@"%ld",(long)_hotCellModel.numberOfComment];
    self.timeLabel.text = _hotCellModel.time;
    

    
}



@end
