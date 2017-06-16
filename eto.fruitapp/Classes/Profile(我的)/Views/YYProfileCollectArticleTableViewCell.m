//
//  YYProfileCollectArticleTableViewCell.m
//  eto.fruitapp
//
//  Created by Apple on 16/2/22.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "YYProfileCollectArticleTableViewCell.h"
#import "UIImageView+WebCache.h"



#define CONTENTTEXTCOLOR [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1]
#define TIMETEXTCOLOR [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1]

@interface YYProfileCollectArticleTableViewCell ()


@property (nonatomic,weak) UILabel *titleLabel; //文章标题框
@property (nonatomic,weak) UIImageView *headImageView;//头像的框
@property (nonatomic,weak) UILabel *authorName;//作者名字
@property (nonatomic,weak) UILabel *contentWordLabel;//介绍框
@property (nonatomic,weak) UIImageView *pictureImageView;//图片框
@property (nonatomic,weak) UILabel *timeLabel;//收藏时间

@end


@implementation YYProfileCollectArticleTableViewCell

+(instancetype)YYProfileCollectArticleTableViewWithTableView:(UITableView *)tableview{
    static NSString *indenti = @"YYProfileCollectArticleTableViewCell";
    YYProfileCollectArticleTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:indenti];
    if (!cell) {
        cell = [[YYProfileCollectArticleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenti];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //标题
        UILabel *titlelb = [[UILabel alloc] init];
        titlelb.frame = CGRectMake(YY16WidthMargin, YY10HeightMargin, widthScreen - YY16WidthMargin - YY16WidthMargin, 20);
        [self.contentView addSubview:titlelb];
        self.titleLabel = titlelb;
        self.titleLabel.font = [UIFont systemFontOfSize:19];
        self.titleLabel.textAlignment = 0;
        
        //作者头像
        UIImageView *authorheadIV = [[UIImageView alloc]init];
        authorheadIV.frame = CGRectMake(YY16WidthMargin, titlelb.frame.origin.y+titlelb.frame.size.height+YY10HeightMargin, 46/375.0*widthScreen, 46/667.0*heightScreen);
        authorheadIV.layer.cornerRadius = authorheadIV.frame.size.width/2.0;
        authorheadIV.layer.masksToBounds = YES;
        [self.contentView addSubview:authorheadIV];
        self.headImageView = authorheadIV;
        
        //作者的用户名
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(authorheadIV.frame.origin.x + authorheadIV.frame.size.width +YY10WidthMargin, YY10HeightMargin*1.5 + titlelb.frame.origin.y+titlelb.frame.size.height, (widthScreen - (authorheadIV.frame.origin.x + authorheadIV.frame.size.width +YY10WidthMargin +YY16WidthMargin+2*YY16WidthMargin))/2, 17)];
        authorLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:authorLabel];
        self.authorName = authorLabel;
        //self.authorName.backgroundColor = [UIColor greenColor];
        
        //收藏时间
        UILabel *collectTime = [[UILabel alloc]initWithFrame:CGRectMake(widthScreen-60/widthScreen*375.0 - YY16WidthMargin, authorLabel.frame.origin.y, 60/widthScreen*375.0, 17)];
        collectTime.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:collectTime];
        self.timeLabel = collectTime;
        //self.timeLabel.backgroundColor = [UIColor blackColor];
        
        
        //内容（简介）
        UILabel *introlb = [[UILabel alloc] init];
        introlb.frame = CGRectMake(YY16WidthMargin, authorheadIV.frame.origin.y + authorheadIV.frame.size.height + YY10HeightMargin, (375-16-16)/375.0*widthScreen, 29);
        [self.contentView addSubview:introlb];
        introlb.numberOfLines = 0;
        introlb.font = [UIFont systemFontOfSize:14];
        introlb.textColor = CONTENTTEXTCOLOR;
        self.contentWordLabel = introlb;
        
        
        //大图
        UIImageView *pic = [[UIImageView alloc] init];
        pic.frame = CGRectMake(YY16WidthMargin, introlb.frame.origin.y + introlb.frame.size.height + YY10HeightMargin, widthScreen - 2 * YY16WidthMargin, 105/667.0*heightScreen);
        [self.contentView addSubview:pic];
        self.pictureImageView = pic;
        
        self.rowheight = pic.frame.origin.y + pic.frame.size.height +YY10HeightMargin;
    }
    return self;
}

- (void)setModel:(YYCollectionArticleModel *)model{
    self.titleLabel.text = model.title;
    [self.headImageView sd_setImageWithURL:model.headimg placeholderImage:[UIImage imageNamed:@"14"] options:SDWebImageRetryFailed];
    self.authorName.text = model.userName;
    self.timeLabel.text = model.time;
    self.contentWordLabel.text = model.intro;
    [self.pictureImageView sd_setImageWithURL:model.img placeholderImage:[UIImage imageNamed:@"home_time"]];
    
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
