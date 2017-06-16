//
//  YYEvaluateCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYEvaluateCell.h"
#import "YYEvaluateFrame.h"
#import "YYEvaluateModel.h"

@interface YYEvaluateCell ()

@property (nonatomic, weak) UIImageView *userIconImageView;//用户头像
@property (nonatomic, weak) UILabel *phoneLabel;//用户手机号
@property (nonatomic, weak) UILabel *dataLabel;//哪一天
@property (nonatomic, weak) UILabel *timeLabel;//具体时间
@property (nonatomic, weak) UILabel *deliverySpeedLabel; //送餐速度
@property (nonatomic, weak) UILabel *evaluateLabel;//用户评价

//五颗星星的imageView
@property (nonatomic, weak) UIImageView *star1;
@property (nonatomic, weak) UIImageView *star2;
@property (nonatomic, weak) UIImageView *star3;
@property (nonatomic, weak) UIImageView *star4;
@property (nonatomic, weak) UIImageView *star5;


@end

@implementation YYEvaluateCell
+ (instancetype)evaluateCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"evaluateCell";
    YYEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加头像
        UIImageView *userIcon = [[UIImageView alloc] init];
        //用户头像x17；W42；Y16
        userIcon.frame = CGRectMake(17, 16, 42, 42);
        [self.contentView addSubview:userIcon];
        self.userIconImageView = userIcon;
        
        //添加用户手机号W82,H20
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.frame = CGRectMake(60, 20, 82, 20);
        [self.contentView addSubview:phoneLabel];
        self.phoneLabel = phoneLabel;
        
         //添加哪一天X242 W80
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(242, 20, 80, 20)];
        [self.contentView addSubview:dataLabel];
        self.dataLabel = dataLabel;
        
        //添加具体时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(325, 20, 35, 20)];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;

         //添加送餐速度W93;Y38;X132,H16
        UILabel *speedLabe = [[UILabel alloc] initWithFrame:CGRectMake(140, 40, 110, 16)];
        [self.contentView addSubview:speedLabe];
        self.deliverySpeedLabel = speedLabe;
        
         //添加五颗星星的imageView第一课x60,WH13;Y36
        CGFloat starX = 60;
        CGFloat starY = 40;
        CGFloat starW = 13;
        CGFloat starH = 13;
        self.star1 = [self addStarImageWithFrame:CGRectMake(starX, starY, starW, starH)];
        self.star2 = [self addStarImageWithFrame:CGRectMake(starX + 15, starY, starW, starH)];
        self.star3 = [self addStarImageWithFrame:CGRectMake(starX + 30, starY, starW, starH)];
        self.star4 = [self addStarImageWithFrame:CGRectMake(starX + 45, starY, starW, starH)];
        self.star5 = [self addStarImageWithFrame:CGRectMake(starX + 60, starY, starW, starH)];
        
         //添加用户评价
        UILabel *customEvaluateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:customEvaluateLabel];
        self.evaluateLabel = customEvaluateLabel;
        
    }
    return self;
}
//添加星星
- (UIImageView *)addStarImageWithFrame:(CGRect)frame{
    UIImageView *starImage = [[UIImageView alloc] initWithFrame:frame];
    starImage.image = [UIImage imageNamed:@"sort_star_green"];
    starImage.hidden = YES;
    [self.contentView addSubview:starImage];
    return starImage;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置单元格内容
- (void)setEvaluateFrame:(YYEvaluateFrame *)evaluateFrame{
    _evaluateFrame = evaluateFrame;
    //清空上次的内容
    self.userIconImageView.image = nil;
    self.phoneLabel.text = nil;
    self.dataLabel.text = nil;
    self.timeLabel.text = nil;
    self.deliverySpeedLabel.text = nil;
    self.evaluateLabel.text = nil;
    self.star1.hidden = YES;
    self.star2.hidden = YES;
    self.star3.hidden = YES;
    self.star4.hidden = YES;
    self.star5.hidden = YES;
    
    YYEvaluateModel *model = evaluateFrame.model;
    
    self.userIconImageView.image = model.userIcon;
    
    self.phoneLabel.text = model.phone;
    [self setLabelTextWithLabel:self.phoneLabel];
    
    self.dataLabel.text = model.data;
    [self setLabelTextWithLabel:self.dataLabel];
    
    self.timeLabel.text = model.time;
    [self setLabelTextWithLabel:self.timeLabel];
    
    if (model.deliverySpeed) {
        self.deliverySpeedLabel.text = [NSString stringWithFormat:@"送餐速度：%ld分钟", (long)model.deliverySpeed];
        [self setLabelTextWithLabel:self.deliverySpeedLabel];
    }
    switch (model.starCount) {
        case 1:
            self.star1.hidden = NO;
            break;
        case 2:
            self.star1.hidden = NO;
            self.star2.hidden = NO;
            break;
        case 3:
            self.star1.hidden = NO;
            self.star2.hidden = NO;
            self.star3.hidden = NO;
            break;
        case 4:
            self.star1.hidden = NO;
            self.star2.hidden = NO;
            self.star3.hidden = NO;
            self.star4.hidden = NO;
            break;
        case 5:
            self.star1.hidden = NO;
            self.star2.hidden = NO;
            self.star3.hidden = NO;
            self.star4.hidden = NO;
            self.star5.hidden = NO;
            break;
        default:
            break;
    }
    
    if (model.evaluate) {
        self.evaluateLabel.frame = evaluateFrame.evaluateLabelFrame;
        self.evaluateLabel.text = model.evaluate;
        self.evaluateLabel.numberOfLines = 0;
    }
}
- (void)setLabelTextWithLabel:(UILabel *)label{
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
}
@end
