//
//  YYOfficAndCustomTableViewCell.m
//  OfficAndCustomColdModel
//
//  Created by Apple on 15/12/6.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYOfficColdCell.h"
#import "YYOfficColdCellModel.h"
#import "YYOfficColdCellFrame.h"


#define CONTENTTEXTCOLOR [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1]
#define TIMETEXTCOLOR [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1]

@interface YYOfficColdCell ()
@property (nonatomic,weak) UILabel *leftTitleLabel;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *contentWordLabel;
@property (nonatomic,weak) UIImageView *pictureImageView;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UIImageView *ZanImageView;
@property (nonatomic,weak) UILabel *numberZanLabel;
@property (nonatomic,weak) UIImageView *commentImageView;
@property (nonatomic,weak) UILabel *numberCommentLabel;

@end

@implementation YYOfficColdCell

+ (instancetype)OfficAndCustomColdCellWithTableView:(UITableView *)tableView{
    static NSString *indenti = @"officAndCustomColdCell";
    YYOfficColdCell *cell = [tableView dequeueReusableCellWithIdentifier:indenti];
    if (!cell) {
        cell = [[YYOfficColdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenti];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //左上角的label
        UILabel *view1 = [[UILabel alloc] init];
        view1.frame = CGRectMake(YY16WidthMargin, YY10HeightMargin, 64/2, 30/2);
        [self.contentView addSubview:view1];
        view1.font = [UIFont systemFontOfSize:12];
        view1.backgroundColor = [UIColor colorWithRed:165/255.0 green:135/255.0 blue:30/255.0 alpha:1];
        view1.textColor = [UIColor whiteColor];
        view1.textAlignment = 1;
        self.leftTitleLabel = view1;
        
        //标题
        UILabel *view2 = [[UILabel alloc] init];
        CGFloat view2X = (16+32+8)/375.0*widthScreen;
        view2.frame = CGRectMake(view2X, YY10HeightMargin, widthScreen - view2X - YY16WidthMargin, 14);
        [self.contentView addSubview:view2];
        self.titleLabel = view2;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = 0;
        
        //内容（简介）
        UILabel *view3 = [[UILabel alloc] init];
        view3.frame = CGRectMake(YY16WidthMargin, (10+15+10)/667.0*heightScreen, (375-16-16)/375.0*widthScreen, 29);
        [self.contentView addSubview:view3];
        view3.numberOfLines = 2;
        view3.font = [UIFont systemFontOfSize:12];
        view3.textColor = CONTENTTEXTCOLOR;
        self.contentWordLabel = view3;
        
        
        //大图
        UIImageView *view4 = [[UIImageView alloc] init];
        view4.frame = CGRectMake(YY16WidthMargin, (10+15+10+10)/667.0*heightScreen+29, widthScreen - 2 * YY16WidthMargin, 105/667.0*heightScreen);
        [self.contentView addSubview:view4];
        self.pictureImageView = view4;
        
        //时间
        UILabel *view5 = [[UILabel alloc] init];
        view5.frame = CGRectMake(YY16WidthMargin,  (10+15+10+10+105+10)/667.0*heightScreen+29, 100, 12);
        [self.contentView addSubview:view5];
        view5.font = [UIFont systemFontOfSize:12];
        view5.textColor = TIMETEXTCOLOR;
        self.timeLabel = view5;
        
        //赞图
        UIImageView *view6 = [[UIImageView alloc] init];
        view6.frame = CGRectMake(widthScreen - 83 -16,(10+15+10+10+105+3+2)/667.0*heightScreen+29, 15, 15);
        [self.contentView addSubview:view6];
        self.ZanImageView = view6;
        self.ZanImageView.image = [UIImage imageNamed:@"littleCold_zan"];
        
        //赞数
        UILabel *view7 = [[UILabel alloc] init];
        view7.frame = CGRectMake(widthScreen - 81,(10+15+10+10+105+3+3+2)/667.0*heightScreen+29, 30, 12);
        [self.contentView addSubview:view7];
        view7.font = [UIFont systemFontOfSize:11];
        view7.textColor = TIMETEXTCOLOR;
        self.numberZanLabel = view7;
    
        
        //评论图
        UIImageView *view8 = [[UIImageView alloc] init];
        view8.frame = CGRectMake(widthScreen - 50,(10+15+10+10+105+3+2)/667.0*heightScreen+29, 15, 15);
        [self.contentView addSubview:view8];
        self.commentImageView = view8;
        self.commentImageView.image = [UIImage imageNamed:@"littleCold_comment_n"];
        
        //评论数
        UILabel *view9 = [[UILabel alloc] init];
        view9.frame = CGRectMake(widthScreen - 30.5,(10+15+10+10+105+3+3+2)/667.0*heightScreen+29, 16, 12);
        [self.contentView addSubview:view9];
        view9.font = [UIFont systemFontOfSize:11];
        view9.textColor = TIMETEXTCOLOR;
        self.numberCommentLabel = view9;
    }
    return self;
}

-(void)setCellFrame:(YYOfficColdCellFrame *)cellFrame{
    _cellFrame = cellFrame;
    YYOfficColdCellModel *model = cellFrame.officAndCustomModel;
    
    self.leftTitleLabel.text = model.leftTitle;
    self.titleLabel.text = model.title;
    self.contentWordLabel.text = model.contentWord;

    NSString *ImageUrlStr = [model.pictureImageURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:ImageUrlStr] placeholderImage:nil options:SDWebImageRetryFailed];
    self.timeLabel.text = model.time;
  
    self.numberZanLabel.text = [NSString stringWithFormat:@"%ld",(long)model.numberZan];
 
    self.numberCommentLabel.text = [NSString stringWithFormat:@"%ld",(long)model.numberComment];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
