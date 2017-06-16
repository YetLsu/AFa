//
//  YYFruitCollectionCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/16.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYFruitCollectionCell.h"
#import "YYFruitCollectionModel.h"
@interface YYFruitCollectionCell ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;

@end
@implementation YYFruitCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 20)];
        [self.contentView addSubview:textlabel];
        self.nameLabel = textlabel;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel.alpha = 0.7;
        
        
        
    }
    return self;
}

- (void)setModel:(YYFruitCollectionModel *)model{
    _model = model;
    
    self.iconView.image = [UIImage imageNamed:_model.icon];
    self.nameLabel.text = _model.name;
}
@end
