//
//  YYTimeFruitCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/21.
//  Copyright © 2015年 wyy. All rights reserved.
//
//cell高120

#import "YYTimeFruitCell.h"
#import "YYTimeFruitModel.h"
#define FONT15 [UIFont systemFontOfSize:15]
#define FONT13 [UIFont systemFontOfSize:13]
@interface YYTimeFruitCell ()
@property (nonatomic, weak) UIImageView *fruitImageView;
@property (nonatomic, weak) UILabel *shopNameLabel;
@property (nonatomic, weak) UILabel *fruitNameLabel;
@property (nonatomic, weak) UILabel *fruitCapacityLabel;//水果容量
@property (nonatomic, weak) UILabel *fruitPrcieLabel;
@property (nonatomic, weak) UILabel *saleNumberLabel;

@end
@implementation YYTimeFruitCell
+ (instancetype)timeFruitCellWithTableView:(UITableView *)tableView{
    static NSString *fruitID = @"YYTimeFruitCell";
    YYTimeFruitCell *cell = [tableView dequeueReusableCellWithIdentifier:fruitID];
    if (!cell) {
        cell = [[YYTimeFruitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fruitID];
    }
    return cell;
}
- (UILabel *)labelWithFrame:(CGRect )labelFrame andLabelFont:(UIFont *)font andTextColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = font;
    label.textColor = color;
    [self.contentView addSubview:label];
    return label;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 7.5, 105, 105)];
        [self.contentView addSubview:imageView];
        self.fruitImageView = imageView;
        //水果名
        self.fruitNameLabel = [self labelWithFrame:CGRectMake(130, 7.5, 115, 18) andLabelFont:[UIFont systemFontOfSize:16] andTextColor:[UIColor blackColor]];
        //份量
        self.fruitCapacityLabel = [self labelWithFrame:CGRectMake(130 + 120, 10, 35, 15) andLabelFont:[UIFont systemFontOfSize:14] andTextColor:YYGrayTextColor];
        //店名
        self.shopNameLabel = [self labelWithFrame:CGRectMake(130 , 35, 115, 15) andLabelFont:[UIFont systemFontOfSize:15] andTextColor:YYGrayTextColor];
        
        UILabel *label = [self labelWithFrame:CGRectMake(130, 96, 15, 18) andLabelFont:FONT15 andTextColor:YYGreenBGColor];
        label.text = @"¥";
        //水果价格
        self.fruitPrcieLabel = [self labelWithFrame:CGRectMake(130 + 10, 96, 20, 18) andLabelFont:FONT15 andTextColor:YYGreenBGColor];
        //销售量
        self.saleNumberLabel = [self labelWithFrame:CGRectMake(130 +15 + 20 + 2, 97, 90, 20) andLabelFont:FONT13 andTextColor:YYGrayTextColor];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(595.0/2, 175.0/2, 61, 26)];
        [self.contentView addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:@"003"] forState:UIControlStateNormal];
        [btn setTitle:@"点一份" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectOneClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}
//点一份按钮被点击
- (void)selectOneClick:(UIButton *)btn{
    
}
//重写模型的setter方法设置数据
- (void)setModel:(YYTimeFruitModel *)model{
    _model = model;
    
    self.fruitImageView.image = _model.fruitImage;
    self.shopNameLabel.text = _model.shopName;
    self.fruitNameLabel.text = _model.fruitName;
    self.fruitCapacityLabel.text = _model.fruitCapacity;
    self.fruitPrcieLabel.text = [NSString stringWithFormat:@"%.0f",_model.fruitPrcie];
    self.saleNumberLabel.text = [NSString stringWithFormat:@"已售%ld份",_model.saleNumber];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
