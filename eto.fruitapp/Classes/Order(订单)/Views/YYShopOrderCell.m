//
//  YYShopOrderCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/19.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYShopOrderCell.h"
#import "YYShopOrderFrame.h"
#import "YYShopOrderModel.h"

#define YYOrderGrayColor [UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:1]
#define YY13Font [UIFont systemFontOfSize:13]

@interface YYShopOrderCell ()
@property (nonatomic, weak) UILabel *stateLabel;
@property (nonatomic, weak) UIImageView *shopImage;
@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UILabel *shopNameLabel;
@property (nonatomic, weak) UILabel *numberPriceLabel;

@property (nonatomic, weak) UIView *lineView;
@property (nonatomic,weak) UIButton *btn;

@end

@implementation YYShopOrderCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//自定义创建cell
+ (instancetype)shopOrderCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"shopOrderCell";
    YYShopOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYShopOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
//重写创建cell的方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 70, 26)];
        [self.contentView addSubview:stateLabel];
        self.stateLabel = stateLabel;
        self.stateLabel.font = YY13Font;
        
        //添加图标
        UIImageView *shopImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 26, 50, 50)];
        [self.contentView addSubview:shopImage];
        self.shopImage = shopImage;
        self.imageView.contentMode = UIViewContentModeCenter;
        
        //设置时间
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 150, 26)];
        [self.contentView addSubview:dateLabel];
        dateLabel.textColor = YYOrderGrayColor;
        self.dateLabel = dateLabel;
        self.dateLabel.font = [UIFont systemFontOfSize:15];
         
        //设置店铺名称
        UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 28, 150, 20)];
        [self.contentView addSubview:shopNameLabel];
        self.shopNameLabel = shopNameLabel;
        
        //设置份数和价格
        UILabel *numberPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 55, 150, 16)];
        [self.contentView addSubview:numberPriceLabel];
        self.numberPriceLabel = numberPriceLabel;
        self.numberPriceLabel.textColor = YYOrderGrayColor;
        self.numberPriceLabel.font = YY13Font;
        
        //设置中间分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, widthScreen, 0.5)];
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        self.lineView.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
        
        //设置支付按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(270, 90, 80, 28)];
        [self.contentView addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:@"order_btnBGOrange"] forState:UIControlStateNormal];
        [btn setTitle:@"去支付" forState:UIControlStateNormal];
        [btn setTitleColor:YYOrangeColor forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        self.btn = btn;
        [self.btn addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
/**
 *  点击去支付
 */
- (void)gotoPay{
    if ([self.delegate respondsToSelector:@selector(gotoPayControllerWithModel:)]) {
        [self.delegate gotoPayControllerWithModel:self.orderFrame.model];
    }
}
- (void)setOrderFrame:(YYShopOrderFrame *)orderFrame{
    _orderFrame = orderFrame;
    YYShopOrderModel *model = _orderFrame.model;
    if (model.orderState == YYOrderStateCancel || model.orderState == YYORderStateFinishOrder || model.orderState ==YYOrderStateFinishPay || model.orderState == YYOrderStateWaitSaller) {//取消订单
        self.lineView.hidden = YES;
        self.btn.hidden = YES;
        self.stateLabel.textColor = YYOrderGrayColor;
        switch (model.orderState) {
            case YYOrderStateCancel:
                self.stateLabel.text = @"订单已取消";
                self.stateLabel.textColor = [UIColor blackColor];
                break;
            case YYORderStateFinishOrder:
                self.stateLabel.text = @"订单已完成";
                 self.stateLabel.textColor = [UIColor blackColor];
                break;
            case YYOrderStateFinishPay:
                self.stateLabel.text = @"等待接单";
                 self.stateLabel.textColor = YYGreenColor;
                break;
            case YYOrderStateWaitSaller:
                self.stateLabel.text = @"等待配送";
                self.stateLabel.textColor = YYGreenColor;
                break;
            default:
                break;
        }
        
    }
    else if (model.orderState == YYOrderStateNeedPay){
        self.lineView.hidden = NO;
        self.btn.hidden = NO;
        
        self.stateLabel.textColor = YYOrangeColor;
        self.stateLabel.text = @"等待支付";
    }
    
    self.shopImage.image = model.shopImage;
    self.dateLabel.text = model.orderDate;
    self.shopNameLabel.text = model.shopName;
    self.numberPriceLabel.text = [NSString stringWithFormat:@"%ld份¥%.2f",model.number, model.price];
    
}
@end
