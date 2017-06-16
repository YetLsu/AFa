//
//  YYWalletCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/30.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYWalletCell.h"
#import "YYWalletModel.h"

@interface YYWalletCell ()
@property (weak, nonatomic) UILabel *buyExpenseLabel;//消费或退款

@property (weak, nonatomic) UILabel *remainingSum;

@property (weak, nonatomic) UILabel *dateLabel;

@property (weak, nonatomic) UILabel *moneyLabel;
@end

@implementation YYWalletCell

+ (instancetype)walletCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYWalletCell";
    YYWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat margin = 15 / 375.0 * widthScreen;
        
        UILabel *buyExpenseLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 6, 120, 16)];
        [self.contentView addSubview:buyExpenseLabel];
        self.buyExpenseLabel = buyExpenseLabel;
        self.buyExpenseLabel.font = [UIFont systemFontOfSize:15];
        self.buyExpenseLabel.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
        
        UILabel *remainingSumLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 23, 100, 13)];
        [self.contentView addSubview:remainingSumLabel];
        self.remainingSum = remainingSumLabel;
        self.remainingSum.font = [UIFont systemFontOfSize:13];
        self.remainingSum.textColor = YYGrayTextColor;
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen - margin - 75, 6, 75, 16)];
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        self.dateLabel.font = [UIFont systemFontOfSize:13];
        self.dateLabel.textColor = YYGrayTextColor;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen - margin - 150 , 21, 150, 16)];
        [self.contentView addSubview:moneyLabel];
        self.moneyLabel = moneyLabel;
        self.moneyLabel.font = [UIFont systemFontOfSize:15];
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YYWalletModel *)model{
    _model = model;
    self.buyExpenseLabel.text = model.buyExpense;
    self.remainingSum.text = model.remainingSum;
    self.dateLabel.text = model.data;
    self.moneyLabel.text = model.money;
    if (model.isIncome) {//是收入
        self.moneyLabel.textColor = YYYellowTextColor;
    }else{
        self.moneyLabel.textColor = YYGreenColor;
    }
}

@end
