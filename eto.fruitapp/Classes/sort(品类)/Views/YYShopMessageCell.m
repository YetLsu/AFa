//
//  YYShopMessageCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/10.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYShopMessageCell.h"
#import "YYShopMessageFrame.h"
#import "YYShopMessageModel.h"


@interface YYShopMessageCell ()

@property (nonatomic, weak) UIImageView *leftView;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, weak) UILabel *textlabel;
@end

@implementation YYShopMessageCell
+ (instancetype)shopMessageCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"shopMessageCell";
    YYShopMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYShopMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //左边图标
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 20, 20)];
        leftImage.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:leftImage];
        self.leftView = leftImage;
        
        //文字
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        self.textlabel = label;
        label.numberOfLines = 0;
      
        //右边按钮
        UIButton *rightBtn = [[UIButton alloc] init];
        [self.contentView addSubview:rightBtn];
        self.rightBtn = rightBtn;
        
        //用kvo监听按钮的highlighted属性,可以在context中传入商店的地址
        [self.rightBtn addTarget:self action:@selector(selectWay) forControlEvents:UIControlEventTouchUpInside];
//        [self.rightBtn addObserver:self forKeyPath:@"highlighted" options: NSKeyValueObservingOptionNew context:@"aaaa"];
    }
    return self;
}
//点击指路
- (void)selectWay{
    if ([self.delegate respondsToSelector:@selector(selectWayClick)]) {
        [self.delegate selectWayClick];
    }
}
- (void)setMessageFrame:(YYShopMessageFrame *)messageFrame{
    _messageFrame = messageFrame;
    
    YYShopMessageModel *model = messageFrame.model;
    self.leftView.image = model.leftIcon;
    
    self.textlabel.text = model.text;
    self.textLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    self.textlabel.frame = messageFrame.labelFrame;
    
    if (model.rightIcon) {
        [self.rightBtn setImage:model.rightIcon forState:UIControlStateNormal];
        self.rightBtn.frame = messageFrame.rightIconFrame;
    }
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
