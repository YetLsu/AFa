//
//  YYNoticCenterTableViewCell.m
//  通知中心
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYNoticCenterTableViewCell.h"
#import "YYNoticCenterModel.h"

#define YY16WidthMargin 16/375.0*widthScreen
#define YY10HeightMargin 10/667.0*heightScreen
#define YY15HeightMargin 15/667.0*heightScreen
#define widthScreen [UIScreen mainScreen].bounds.size.width //屏幕宽
#define heightScreen [UIScreen mainScreen].bounds.size.height //屏幕高


@interface YYNoticCenterTableViewCell ()


@property (nonatomic,weak) UILabel *contentLabel;
@property (nonatomic,weak) UILabel *dateLabel;
@property (nonatomic,weak) UIImageView *rightImageView;

@end
@implementation YYNoticCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(id)noticeTableViewCell:(UITableView *)tableView{
    static NSString *ID = @"cell";
    YYNoticCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYNoticCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //黄点
        UIImageView *leftImageView = [[UIImageView alloc] init];
        leftImageView.frame = CGRectMake(YY16WidthMargin, YY16WidthMargin, 7.5, 7.5);
        [self.contentView addSubview:leftImageView];
        self.pointImageView = leftImageView;
        
        //标题
        UILabel *titlelb = [[UILabel alloc] init];
        titlelb.frame = CGRectMake(YY16WidthMargin + 8.5, 11/667.0*heightScreen, 280/375.0*widthScreen, 15);
        titlelb.font = [UIFont systemFontOfSize:14];
        titlelb.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
        [self.contentView addSubview:titlelb];
        self.titleLabel = titlelb;
        
        
        //内容
        UILabel *contentlb = [[UILabel alloc] init];
        contentlb.frame = CGRectMake(YY16WidthMargin + 8.5, 11/667.0*heightScreen + 15 + 5/667.0*heightScreen, 280/375.0*widthScreen, 13);
        contentlb.font = [UIFont systemFontOfSize:12];
        //contentlb.backgroundColor = [UIColor blueColor];
        
        contentlb.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
        [self.contentView addSubview:contentlb];
        self.contentLabel = contentlb;
        
        
        //时间
        
        UILabel *datelb = [[UILabel alloc] init];
        datelb.frame = CGRectMake(widthScreen - YY16WidthMargin - 12 - 100, 16, 100, 12);
        datelb.textAlignment = NSTextAlignmentRight;
        datelb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:datelb];
        self.dateLabel = datelb;
        
        
        //右箭头
        UIImageView *rightIV = [[UIImageView alloc] init];
        rightIV.frame = CGRectMake(widthScreen - YY16WidthMargin - 12, 15, 10, 15);
        rightIV.image = [UIImage imageNamed:@"未标题-2"];
        [self.contentView addSubview:rightIV];
        self.rightImageView = rightIV;
        
        
        
        
        self.rowHeight = 11/667.0*heightScreen + 15 + 5/667.0*heightScreen + 9 + 15/667.0*heightScreen;
    
    }
    return self;
}

- (void)setModel:(YYNoticCenterModel *)model{
    _model = model;
    self.titleLabel.text = _model.titleNotic;
    self.contentLabel.text = [NSString stringWithFormat:@"%@%@",_model.userSay,_model.contentNotic];
    self.dateLabel.text = _model.date;
    
}


@end
