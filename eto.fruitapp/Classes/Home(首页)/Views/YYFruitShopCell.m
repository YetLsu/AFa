//
//  YYFruitShopCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/4.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYFruitShopCell.h"
#import "YYFruitShopModel.h"

@interface YYFruitShopCell ()
//店名
@property (weak, nonatomic) IBOutlet UILabel *shopName;
//地址
@property (weak, nonatomic) IBOutlet UILabel *address;
//营业时间
@property (weak, nonatomic) IBOutlet UILabel *openTime;
//距离
@property (weak, nonatomic) IBOutlet UILabel *distance;
//店图标
@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
//评价是否隐藏改变星星个数
@property (weak, nonatomic) IBOutlet UIImageView *xing0;
@property (weak, nonatomic) IBOutlet UIImageView *xing1;
@property (weak, nonatomic) IBOutlet UIImageView *xing2;

@property (weak, nonatomic) IBOutlet UIImageView *xing3;
@property (weak, nonatomic) IBOutlet UIImageView *xing4;
@property (weak, nonatomic) IBOutlet UIButton *takeWayBtn;

@end

@implementation YYFruitShopCell

+ (instancetype)fruitShopCellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"fruitShopCell";
    YYFruitShopCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[YYFruitShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        [cell.takeWayBtn setTitleColor:YYGreenBGColor forState:UIControlStateHighlighted];
        [cell.takeWayBtn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
        cell.address.textColor = YYGrayTextColor;
        cell.address.font = [UIFont systemFontOfSize:15];
        cell.distance.textColor = YYGrayTextColor;
        cell.openTime.textColor = YYGrayTextColor;
        cell.openTime.font = [UIFont systemFontOfSize:15];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YYFruitShopCell" owner:nil options:nil]lastObject];
        
    }
    return self;
}
- (void)setModel:(YYFruitShopModel *)model{
    _model = model;
    self.shopName.text = model.shopName;
    self.address.text = model.address;
    self.openTime.text = model.openTime;
    self.distance.text = model.distance;
    self.shopIcon.image = model.shopIcon;
    switch (model.xingNumber) {
        case 1:
            self.xing0.hidden = NO;
            break;
        case 2:
            self.xing0.hidden = NO;
            self.xing1.hidden = NO;
            break;
        case 3:
            self.xing0.hidden = NO;
            self.xing1.hidden = NO;
            self.xing2.hidden = NO;
            break;
        case 4:
            self.xing0.hidden = NO;
            self.xing1.hidden = NO;
            self.xing2.hidden = NO;
            self.xing3.hidden = NO;
            break;
        case 5:
            self.xing0.hidden = NO;
            self.xing1.hidden = NO;
            self.xing2.hidden = NO;
            self.xing3.hidden = NO;
            self.xing4.hidden = NO;
            break;
        default:
            break;
    }
}
@end
