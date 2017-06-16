//
//  YYFruitCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/6.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYFruitCell.h"
#import "YYFruitModel.h"

@interface YYFruitCell ()
@property (weak, nonatomic) IBOutlet UIImageView *fruitIcon;
@property (weak, nonatomic) IBOutlet UILabel *fruitName;
@property (weak, nonatomic) IBOutlet UILabel *saleNumber;
@property (weak, nonatomic) IBOutlet UILabel *fruitPreice;

@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectNumber;

@end

@implementation YYFruitCell

- (void)setModel:(YYFruitModel *)model{
    _model = model;
    self.fruitIcon.image = nil;
    self.fruitName.text = nil;
    self.saleNumber.text = nil;
    self.fruitPreice.text = nil;
    self.selectNumber.text = nil;
    
    self.fruitIcon.image = model.fruitIconImage;
    self.fruitName.text = model.fruitName;
    self.saleNumber.text = model.saleNumber;
    self.fruitPreice.text = [NSString stringWithFormat:@"¥%@",model.fruitPreice];
    self.selectNumber.text = [NSString stringWithFormat:@"%ld",model.selectNumber];
    
    if (self.selectNumber.text.integerValue == 0) {
        self.reduceBtn.enabled = NO;
    }else{
        self.reduceBtn.enabled = YES;
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
//        self.selectNumber.hidden = YES;
    }
    NSInteger count = self.selectNumber.text.integerValue;
    count--;
    self.selectNumber.text = [NSString stringWithFormat:@"%ld",(long)count];
    if ([self.delegate respondsToSelector:@selector(cellAllPriceWithModel:)]) {
        self.model.selectNumber = count;
        [self.delegate cellAllPriceWithModel:self.model];
    }
}
/**
 *  增加订购数量
 */
- (IBAction)addBtnClick {
    self.reduceBtn.enabled = YES;
//    self.selectNumber.hidden = NO;
    NSInteger count = self.selectNumber.text.integerValue;
    count++;
    self.selectNumber.text = [NSString stringWithFormat:@"%ld",count];
    if ([self.delegate respondsToSelector:@selector(cellAllPriceWithModel:)]) {
        self.model.selectNumber = count;
        [self.delegate cellAllPriceWithModel:self.model];
    }
}
/**
 *  创建fruitcell单元格
 *
 */
+ (instancetype)fruitCellWithTableView:(UITableView *)tableView{
    static NSString * ID = @"sortFruitCell";
    YYFruitCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYFruitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
//重写方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YYFruitCell" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
