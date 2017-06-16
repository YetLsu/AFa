//
//  YYCircleDetailContentTableViewCell.m
//  圈子_V1
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCircleDetailContentTableViewCell.h"
#import "YYCircleDetailContentModel.h"

#define YY5HeightMargin 5/667.0*heightScreen

@interface YYCircleDetailContentTableViewCell ()
@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,weak)UIImageView *leftImageView;
@property (nonatomic,weak)UILabel *userNameLabel;
@property (nonatomic,weak)UILabel *timeLabel;
@property (nonatomic,weak)UILabel *zanNumberLabel;
@property (nonatomic,weak)UILabel *commentNumberLabel;

//其他的属性
//赞图的位置的x值
@property (nonatomic,assign) CGFloat zanX;

@end

@implementation YYCircleDetailContentTableViewCell


+ (id)circleDetailContentTableViewCell:(UITableView *)table{
    static NSString *ID = @"cell";
    YYCircleDetailContentTableViewCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYCircleDetailContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.timeLabel.text = nil;
    cell.userNameLabel.text = nil;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //标题的label
        UILabel *titlelb = [[UILabel alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY10HeightMargin, widthScreen - 2*YY16WidthMargin, 35)];
        titlelb.font = [UIFont systemFontOfSize:13];
        titlelb.numberOfLines = 2;
        [self.contentView addSubview:titlelb];
        self.titleLabel = titlelb;
        
        //左下方的图片
        UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY10HeightMargin + 30 + YY15HeightMargin, 8/375.0*widthScreen, 12/667.0*heightScreen)];
        leftIV.image = [UIImage imageNamed:@"bgq_detailCircle_beforeID"];
        [self.contentView addSubview:leftIV];
        self.leftImageView = leftIV;
        
        //评论数
        UILabel *commentlb = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen -YY16WidthMargin - 21 , YY10HeightMargin + 30 + YY15HeightMargin + 1, 21, 11)];
        commentlb.textAlignment = 1;
        commentlb.font = [UIFont systemFontOfSize:10];
        commentlb.textColor = [UIColor colorWithRed:235/255.5 green:196/255.0 blue:51/255.0 alpha:1];
        [self.contentView addSubview:commentlb];
        self.commentNumberLabel = commentlb;
        
        //评论图
        UIImageView *commentIV = [[UIImageView alloc] initWithFrame:CGRectMake(commentlb.frame.origin.x - 12, commentlb.frame.origin.y-1, 12, 12)];
        commentIV.image = [UIImage imageNamed:@"bgq_detailCircle_comment"];
        [self.contentView addSubview:commentIV];
        
        //赞数
        UILabel *zanlb = [[UILabel alloc] initWithFrame:CGRectMake(commentIV.frame.origin.x - 21, YY10HeightMargin + 30 + YY15HeightMargin + 1, 21, 11)];
        zanlb.textAlignment = 1;
        zanlb.font = [UIFont systemFontOfSize:10];
        zanlb.textColor = [UIColor colorWithRed:235/255.5 green:196/255.0 blue:51/255.0 alpha:1];
        [self.contentView addSubview:zanlb];
        self.zanNumberLabel = zanlb;
        
        UIImageView *zanIV = [[UIImageView alloc] initWithFrame:CGRectMake(zanlb.frame.origin.x - 12, commentlb.frame.origin.y-1, 12, 12)];
        zanIV.image = [UIImage imageNamed:@"bgq_detailCircle_Zan"];
        [self.contentView addSubview:zanIV];
        
        self.zanX = zanIV.frame.origin.x;
 
        
    }
    return self;
}

- (void)setModel:(YYCircleDetailContentModel *)model{
    YYCircleDetailContentModel *model1 = model;
    //设置用户名label
    CGSize size = [model1.userName boundingRectWithSize:CGSizeMake(MAXFLOAT, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]} context:nil ].size;
    UILabel *userlb = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImageView.frame.origin.x + self.leftImageView.frame.size.width + 5/375.0*widthScreen, self.leftImageView.frame.origin.y +1, size.width, 10)];
    userlb.font = [UIFont systemFontOfSize:10];
    userlb.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
    [self.contentView addSubview:userlb];
    self.userNameLabel = userlb;
    
    //设置时间label
    //NSString *time1 = [NSString stringWithFormat:@""]
    UILabel *timelb = [[UILabel alloc] initWithFrame:CGRectMake(userlb.frame.origin.x + userlb.frame.size.width + YY10WidthMargin*1.5, userlb.frame.origin.y, widthScreen- (userlb.frame.origin.x + userlb.frame.size.width + YY10WidthMargin*1.5)- (widthScreen - self.zanX) , 10)];
    timelb.font = [UIFont systemFontOfSize:10];
    timelb.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
    [self.contentView addSubview:timelb];
    self.timeLabel = timelb;
    
    
    //设置属性
    self.titleLabel.text = model1.title;
    self.userNameLabel.text = model1.userName;
    self.timeLabel.text = model1.time;
    self.zanNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)model1.zanNumber];
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)model1.commentNumber];
    self.cellRowHeight = timelb.frame.origin.y + timelb.frame.size.height + YY10HeightMargin +1;
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
