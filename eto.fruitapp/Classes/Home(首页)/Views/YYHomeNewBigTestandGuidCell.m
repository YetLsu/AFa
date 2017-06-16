//
//  YYHomeNewBigTestandGuidCell.m
//  eto.fruitapp
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "YYHomeNewBigTestandGuidCell.h"
#import "YYHomeNewBigTestModel.h"
#import "UIImageView+WebCache.h"

@interface YYHomeNewBigTestandGuidCell ()
@property (nonatomic,weak) UIImageView *iconImageView;//头像的框
@property (nonatomic,weak) UILabel *nameLabel;//用户名的框
@property (nonatomic,weak) UILabel *titleLabel;//介绍哪一期什么的
@property (nonatomic,weak) UIImageView *picImageView;//每一期的介绍图片
@property (nonatomic,weak) UIView *view;//白色的底层

@end
@implementation YYHomeNewBigTestandGuidCell

+ (instancetype)HomeNewBigTestandGuidCellWithTableView:(UITableView *)table{
    YYHomeNewBigTestandGuidCell *cell = [table dequeueReusableCellWithIdentifier:@"YYHomeNewBigTestandGuidCell"];
    if (!cell) {
        cell = [[YYHomeNewBigTestandGuidCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YYHomeNewBigTestandGuidCell"];
    }
    cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //底部的白色那一层
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(YY16WidthMargin, 0, widthScreen - 2*YY16WidthMargin, 100)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        self.view = view;
        
        //设置头像
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY10WidthMargin, YY15HeightMargin, 46/375.0*widthScreen, 46/667.0*heightScreen)];
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width/2.0;
        iconImageView.layer.masksToBounds = YES;
        [self.view addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        //设置作者的文本框
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width +YY10WidthMargin, YY10HeightMargin*2.5, widthScreen - (iconImageView.frame.origin.x + iconImageView.frame.size.width +YY10WidthMargin +YY16WidthMargin+2*YY16WidthMargin), 17)];
        authorLabel.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:authorLabel];
        self.nameLabel = authorLabel;
    }
    return self;
}

- (void)setModel:(YYHomeNewBigTestModel *)model{
    //设置文字的框
    CGSize  contentSize = [model.intro boundingRectWithSize:CGSizeMake(widthScreen - YY10WidthMargin*2 - 2*YY16WidthMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} context:nil].size;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.frame.origin.x, self.iconImageView.frame.origin.y + self.iconImageView.frame.size.height + YY10HeightMargin, contentSize.width, contentSize.height)];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithRed:221/255.0 green:186/255.0 blue:44/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    self.titleLabel = label;
    
    //设置图片
    UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY10WidthMargin, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + YY10HeightMargin, widthScreen - 2*YY10WidthMargin - 2*YY16WidthMargin, 160/667.0*heightScreen)];
    [self.view addSubview:picImageView];
    self.picImageView = picImageView;
    
    //赋值
    [self.iconImageView sd_setImageWithURL:model.iconUrl placeholderImage:[UIImage imageNamed:@"14"]];
    self.nameLabel.text = model.authorName;
    self.titleLabel.text = model.intro;
    [self.picImageView sd_setImageWithURL:model.imagePicUrl placeholderImage:[UIImage imageNamed:@"littleCold_icon1"]];
    self.rowHeight = self.picImageView.frame.origin.y + self.picImageView.frame.size.height + YY15HeightMargin;
    CGRect rect = self.view.frame;
    rect.size.height = self.rowHeight;
    self.view.frame = rect;
}


@end
