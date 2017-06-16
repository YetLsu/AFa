//
//  YYCircleTableViewCell.m
//  圈子_V1
//
//  Created by Apple on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCircleTableViewCell.h"
#import "YYCircleModel.h"
#import "UIImageView+WebCache.h"


#define YY5HeightMargin 5/667.0*heightScreen

@interface YYCircleTableViewCell ()
@property (nonatomic,weak) UIImageView *leftImageView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *replyLabel;
@property (nonatomic,weak) UILabel *contentLabel;
@property (nonatomic,weak) UILabel *joinAndReadLabel;

//其他属性
@property (nonatomic,copy) NSString *titleT;

@end

@implementation YYCircleTableViewCell




+ (id)circleTableView:(UITableView *)tableView{
    //static NSString *ID = @"cell1";
    YYCircleTableViewCell *cell = [[YYCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //左图
        UIImageView *leftIV = [[UIImageView alloc] init];
        leftIV.backgroundColor = [UIColor yellowColor];
        leftIV.frame = CGRectMake(YY16WidthMargin, YY10WidthMargin, 60/375.0*widthScreen, 60/667.0*heightScreen);
        [self.contentView addSubview:leftIV];
        self.leftImageView = leftIV;
        
//        //前缀的标题
//        UILabel *titlelb = [[UILabel alloc] init];
//        CGSize size1 = [self.titleT boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
//        NSLog(@"A------------%f",size1.width);
//        if (size1.width < (394/2)/375.0*widthScreen) {
//            size1.width = (394/2)/375.0*widthScreen;
//        }
//        NSLog(@"B------------%f",size1.width);
//        titlelb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin, 18/667.0*heightScreen, size1.width, 13);
//        titlelb.font = [UIFont systemFontOfSize:12];
//        [self.contentView addSubview:titlelb];
//        self.titleLabel = titlelb;
//        
//        //回复数
//        UILabel *replylb = [[UILabel alloc] init];
//        replylb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin +size1.width, 20/667.0*heightScreen + 5/375.0*widthScreen, 65/375.0*widthScreen, 9);
//        replylb.textColor = [UIColor colorWithRed:181/255.0 green:151/255.0 blue:39/255.0 alpha:1];
//        replylb.font = [UIFont systemFontOfSize:8];
//        [self.contentView addSubview:replylb];
//        self.replyLabel = replylb;
        
        //描述性内容
        UILabel *contentlb = [[UILabel alloc] init];
        contentlb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin, 18/667.0*heightScreen + 13 + YY5HeightMargin, 540/2/375.0*widthScreen, 12);
        contentlb.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
        contentlb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:contentlb];
        self.contentLabel = contentlb;
        
        //参与阅读
        UILabel *joinAndreadlb = [[UILabel alloc] init];
        joinAndreadlb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin, 18/667.0*heightScreen + 13 + YY5HeightMargin +12 +YY5HeightMargin, 540/2/375.0*widthScreen, 10);
        joinAndreadlb.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
        joinAndreadlb.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:joinAndreadlb];
        self.joinAndReadLabel = joinAndreadlb;
        
        //设置cell的高度
        self.cellRowHeight = self.leftImageView.frame.size.height + 2*YY10WidthMargin;
    }
    return self;
}

- (void)setModel:(YYCircleModel *)model{
    _model = model;
    NSURL *iconURLStr = [NSURL URLWithString:_model.leftImageName];
    
    [self.leftImageView sd_setImageWithURL:iconURLStr placeholderImage:[UIImage imageNamed:@"bgq_circle_headImage"]];
    YYLog(@"%@",_model.leftImageName);
    //self.leftImageView.image = [UIImage imageNamed:@"bgq_circle_headImage"];//[UIImage imageNamed:_model.leftImageName];
    self.titleT = [NSString stringWithFormat:@"#%@#",_model.prefixTitle];
    
    
    //前缀的标题
    UILabel *titlelb = [[UILabel alloc] init];
    CGSize size1 = [self.titleT boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
//    YYLog(@"A------------%f",size1.width);
    if (size1.width > (394/2)/375.0*widthScreen) {
        size1.width = (394/2)/375.0*widthScreen;
    }
//    YYLog(@"B------------%f",size1.width);
    titlelb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin, 18/667.0*heightScreen, size1.width, 13);
    titlelb.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titlelb];
    self.titleLabel = titlelb;
    
    //回复数
    UILabel *replylb = [[UILabel alloc] init];
    replylb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin +size1.width+5,18/667.0*heightScreen+13 - 10 , 65/375.0*widthScreen, 9);
    replylb.textColor = [UIColor colorWithRed:181/255.0 green:151/255.0 blue:39/255.0 alpha:1];
//    YYLog(@"c----------%f",replylb.frame.origin.x);
    replylb.font = [UIFont systemFontOfSize:8];
    [self.contentView addSubview:replylb];
    self.replyLabel = replylb;

//    YYLog(@"%@",self.titleT);
    self.titleLabel.text = self.titleT;
    self.replyLabel.text = [NSString stringWithFormat:@"今日：%ld",(long)_model.replyNumber];
    self.contentLabel.text = _model.content;
    self.joinAndReadLabel.text = [NSString stringWithFormat:@"%ld人参与丨%ld万阅读",(long)_model.joinNumber,(long)_model.readNumber];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
