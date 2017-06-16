//
//  YYBuyShopCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/5.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYBuyShopCell.h"
#import "YYBuyShopModel.h"

@interface YYBuyShopCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *sellCount;

@property (weak, nonatomic) IBOutlet UILabel *startCarry;

@property (weak, nonatomic) IBOutlet UILabel *carry;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIImageView *xin0;
@property (weak, nonatomic) IBOutlet UIImageView *xin1;
@property (weak, nonatomic) IBOutlet UIImageView *xin2;
@property (weak, nonatomic) IBOutlet UIImageView *xin3;
@property (weak, nonatomic) IBOutlet UIImageView *xin4;


@end

@implementation YYBuyShopCell

+ (instancetype)buyShopCellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"buyShopCell";
    YYBuyShopCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell) {
        cell = [[YYBuyShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YYBuyShopCell" owner:nil options:nil] lastObject];
    }
    return self;
}
- (void) setModel:(YYBuyShopModel *)model{
    _model = model;
    self.name.text = model.name;
    self.icon.image = model.shopIcon;
    self.sellCount.text = model.sellCount;
    self.startCarry.text = model.startCarryPrice;
    self.carry.text = model.carryPrice;
    self.time.text = model.time;
    
    switch (model.xingNum) {
        case 1:
            self.xin0.hidden = NO;
            break;
        case 2:
            self.xin0.hidden = NO;
            self.xin1.hidden = NO;
            break;
        case 3:
            self.xin0.hidden = NO;
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
            break;
        case 4:
            self.xin0.hidden = NO;
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
            self.xin3.hidden = NO;
            break;
        case 5:
            self.xin0.hidden = NO;
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
            self.xin3.hidden = NO;
            self.xin4.hidden = NO;
            break;
        default:
            break;
    }

}
@end
