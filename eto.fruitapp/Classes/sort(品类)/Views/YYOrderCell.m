//
//  YYOrderCell.m
//  点餐系统
//
//  Created by wyy on 15/11/16.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYOrderCell.h"
#import "YYOrderMOdel.h"

@interface YYOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *fruitIcon;
@property (weak, nonatomic) IBOutlet UILabel *fruitName;

@property (weak, nonatomic) IBOutlet UILabel *fruitPreice;

@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectNumber;
@property (nonatomic, assign) NSInteger count;
@property (weak, nonatomic) IBOutlet UIButton *gotoShopBtn;
@end

@implementation YYOrderCell
- (IBAction)gotoShopClick {
    
}
- (instancetype)initWithCell{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YYOrderCell" owner:nil options:nil] lastObject];
        self.fruitPreice.textColor = YYOrangeColor;
        [self.gotoShopBtn setTitleColor:YYGreenGotoshop forState:UIControlStateNormal];
    }
    return self;
}
- (void)setOrderModel:(YYOrderMOdel *)orderModel{
    
    self.fruitIcon.image = nil;
    self.fruitName.text = nil;
    self.fruitPreice.text = nil;
    self.selectNumber.text = nil;
    
    _orderModel = orderModel;
    self.fruitIcon.image = _orderModel.fruitIconImage;
    self.fruitName.text = _orderModel.fruitName;
    NSString *price = [@"¥" stringByAppendingString:_orderModel.fruitPreice];
    self.fruitPreice.text = price;
    self.selectNumber.text = _orderModel.number;
    
    if (self.selectNumber.text.integerValue == 0) {
        self.reduceBtn.enabled = NO;
    }
}
- (void)awakeFromNib{
    self.fruitPreice.textColor = YYGreenColor;

}
/**
 *  减少订购数量
 */
- (IBAction)reduceBtnClick {
    if (self.selectNumber.text.integerValue == 1) {
        self.reduceBtn.enabled = NO;
    }
    self.count = self.selectNumber.text.integerValue;
    self.count --;
    self.selectNumber.text = [NSString stringWithFormat:@"%ld",(long)self.count];
    self.orderModel.number = self.selectNumber.text;
}
/**
 *  增加订购数量
 */
- (IBAction)addBtnClick {
    self.reduceBtn.enabled = YES;
    self.selectNumber.hidden = NO;
    self.count = self.selectNumber.text.integerValue;
    self.count ++;
    self.selectNumber.text = [NSString stringWithFormat:@"%ld",(long)self.count];
    
    self.orderModel.number = self.selectNumber.text;

}
/**
 *  创建fruitcell单元格
 *
 */
+ (instancetype)orderCellWithTableView:(UITableView *)tableView{
    static NSString * ID = @"OrderCell";
    YYOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
//重写方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YYOrderCell" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
